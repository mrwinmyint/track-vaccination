using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Domain.Common;
using CareBaby.Domain.Identity;
using Duende.IdentityServer.EntityFramework.Options;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.Extensions.Options;

namespace CareBaby.Infrastructure.Persistence
{
    public partial class ApplicationDbContext : KeyApiAuthorizationDbContext<ApplicationUser
        , ApplicationRole
        , Guid
        , IdentityUserClaim<Guid>
        , ApplicationUserRoles
        , ApplicationUserLogins
        , IdentityRoleClaim<Guid>
        , IdentityUserToken<Guid>>
        , IApplicationDbContext
    {
        private readonly ICurrentUserService _currentUserService;
        private readonly IDateTimeService _dateTimeService;
        private readonly IDomainEventService _domainEventService;

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options,
            IOptions<OperationalStoreOptions> operationalStoreOptions,
            ICurrentUserService currentUserService,
            IDomainEventService domainEventService,
            IDateTimeService dateTimeService)
        : base(options, operationalStoreOptions)
        {
            _currentUserService = currentUserService;
            _domainEventService = domainEventService;
            _dateTimeService = dateTimeService;
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);

        private static void SetTableNamesAsSingle(ModelBuilder builder)
        {
            // Use the entity name instead of the Context.DbSet<T> name
            foreach (var entityType in builder.Model.GetEntityTypes())
            {
                builder.Entity(entityType.ClrType).ToTable(entityType.ClrType.Name);
            }
        }

        /// <summary>
        /// SaveChangesAsync override method
        /// </summary>
        /// <param name="cancellationToken"></param>
        /// <returns></returns>
        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = new CancellationToken())
        {
            foreach (var entry in ChangeTracker.Entries<EntityBase<Guid>>())
            {
                if (ExcludedEntity(entry))
                {
                    continue;
                }

                switch (entry.State)
                {
                    case EntityState.Added:
                        entry.Entity.CreatedById = _currentUserService.UserId;
                        entry.Entity.Created = _dateTimeService.DateTimeOffsetUtcNow;
                        break;

                    case EntityState.Modified:
                        entry.Entity.LastModifiedById = _currentUserService.UserId;
                        entry.Entity.LastModified = _dateTimeService.DateTimeOffsetUtcNow;
                        break;
                }
            }

            var events = ChangeTracker.Entries<IHasDomainEvent>()
                    .Select(x => x.Entity.DomainEvents)
                    .SelectMany(x => x)
                    .Where(domainEvent => !domainEvent.IsPublished)
                    .ToArray();

            var result = await base.SaveChangesAsync(cancellationToken);

            await DispatchEvents(events);

            return result;
        }

        private async Task DispatchEvents(BaseDomainEvent[] events)
        {
            foreach (var @event in events)
            {
                @event.IsPublished = true;
                await _domainEventService.Publish(@event);
            }
        }

        private bool ExcludedEntity(EntityEntry entry)
        {
            bool excludedEntity = false;
            if (entry.Metadata.ClrType.Name == "ApplicationUser" ||
                    entry.Metadata.ClrType.Name == "ApplicationRole" ||
                    entry.Metadata.ClrType.Name == "ApplicationUserLogin" ||
                    entry.Metadata.ClrType.Name == "ApplicationUserRoles" ||
                    entry.Metadata.ClrType.Name == "AspNetRoleClaims" ||
                    entry.Metadata.ClrType.Name == "AspNetRoles" ||
                    entry.Metadata.ClrType.Name == "AspNetUserClaims" ||
                    entry.Metadata.ClrType.Name == "AspNetUserLogins" ||
                    entry.Metadata.ClrType.Name == "AspNetUserRoles" ||
                    entry.Metadata.ClrType.Name == "AspNetUsers" ||
                    entry.Metadata.ClrType.Name == "AspNetUserTokens" ||
                    entry.Metadata.ClrType.Name == "RefreshToken")
            {
                excludedEntity = true;
            }

            return excludedEntity;
        }
    }
}