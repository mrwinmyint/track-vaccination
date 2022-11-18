using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Domain.Entities;
using CareBaby.Domain.Identity;
using CareBaby.Infrastructure.Configuration;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace CareBaby.Infrastructure.Persistence
{
    public partial class ApplicationDbContext : KeyApiAuthorizationDbContext<Domain.Identity.ApplicationUser
        , Domain.Identity.ApplicationRole
        , Guid
        , IdentityUserClaim<Guid>
        , ApplicationUserRoles
        , ApplicationUserLogins
        , IdentityRoleClaim<Guid>
        , IdentityUserToken<Guid>>
        , IApplicationDbContext
    {
        public virtual DbSet<ActionLog> ActionLogs { get; set; } = null!;
        public virtual DbSet<ChildUser> ChildUsers { get; set; } = null!;
        public virtual DbSet<CustomEntity> CustomEntities { get; set; } = null!;
        public virtual DbSet<DataType> DataTypes { get; set; } = null!;
        public virtual DbSet<DatabaseVersion> DatabaseVersions { get; set; } = null!;
        public virtual DbSet<Dose> Doses { get; set; } = null!;
        public virtual DbSet<RefreshToken> RefreshTokens { get; set; } = null!;
        public virtual DbSet<SettingEmail> SettingEmails { get; set; } = null!;
        public virtual DbSet<SettingGeneral> SettingGenerals { get; set; } = null!;
        public virtual DbSet<SettingSecurityToken> SettingSecurityTokens { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;
        public virtual DbSet<UserAddress> UserAddresses { get; set; } = null!;
        public virtual DbSet<Vaccine> Vaccines { get; set; } = null!;
        public virtual DbSet<VaccineType> VaccineTypes { get; set; } = null!;
        public virtual DbSet<VwUser> VwUsers { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //modelBuilder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

            modelBuilder.Ignore<AspNetUserRoles>();
            modelBuilder.Ignore<AspNetRole>();
            modelBuilder.Ignore<AspNetUser>();
            modelBuilder.Ignore<AspNetUserClaims>();
            modelBuilder.Ignore<AspNetRoleClaims>();

            SetTableNamesAsSingle(modelBuilder);

            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<ActionLog>(entity =>
            {
                entity.ToTable("ActionLog");

                entity.HasIndex(e => e.ActionDateTime, "IX_ActionLog_ActionDateTime")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.ActionTypeId, "IX_ActionLog_ActionTypeId")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.ActionedBy, "IX_ActionLog_ActionedBy")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.CustomEntityId, "IX_ActionLog_CustomEntityId")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.EntityUniqueId, "IX_ActionLog_EntityUniqueId")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.ActionReason).HasMaxLength(1000);

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasDefaultValueSql("('TRUE')");

                entity.Property(e => e.IsDeleted)
                    .IsRequired()
                    .HasDefaultValueSql("('FALSE')");

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Notes).HasMaxLength(1000);

                entity.Property(e => e.SignedInRole).HasMaxLength(256);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.ActionLogs)
                    .HasForeignKey(d => d.ActionedBy)
                    .HasConstraintName("FK_ActionLog_User");

                entity.HasOne(d => d.CustomEntity)
                    .WithMany(p => p.ActionLogs)
                    .HasForeignKey(d => d.CustomEntityId)
                    .OnDelete(DeleteBehavior.ClientSetNull);
            });

            modelBuilder.Entity<ApplicationRole>(entity =>
            {
                entity.ToTable("AspNetRoles");

                entity.HasIndex(e => e.Name, "IX_AspNetRoles_Name")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Name).HasMaxLength(256);

                entity.Property(e => e.NormalizedName).HasMaxLength(256);

                entity.Property(e => e.ConcurrencyStamp);

                entity.HasMany(d => d.ApplicationUserRoles)
                    .WithOne(p => p.Role)
                    .HasForeignKey(ur => ur.RoleId)
                    .IsRequired();
            });

            modelBuilder.Entity<Domain.Identity.ApplicationUser>(entity =>
            {
                entity.ToTable("AspNetUsers");

                entity.HasIndex(e => e.Email, "IX_AspNetUsers_Email")
                    .HasFillFactor<Domain.Identity.ApplicationUser>(90);

                entity.HasIndex(e => e.EmailConfirmed, "IX_AspNetUsers_EmailConfirmed")
                    .HasFillFactor<Domain.Identity.ApplicationUser>(90);

                entity.HasIndex(e => e.UserName, "IX_AspNetUsers_UserName")
                    .HasFillFactor<Domain.Identity.ApplicationUser>(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property<string>(e => e.Email).HasMaxLength(256);

                entity.Property<string>(e => e.NormalizedEmail).HasMaxLength(256);

                entity.Property<string>(e => e.NormalizedUserName).HasMaxLength(256);

                entity.Property<string>(e => e.UserName).HasMaxLength(256);

                entity.HasMany(d => d.ApplicationUserRoles)
                    .WithOne(e => e.User)
                    .HasForeignKey(ur => ur.UserId)
                    .IsRequired();
            });

            modelBuilder.Entity<ApplicationUserRoles>(entity =>
            {
                entity.ToTable("AspNetUserRoles");

                entity.Property(e => e.UserId);

                entity.Property(e => e.RoleId);
            });

            modelBuilder.Entity<ChildUser>(entity =>
            {
                entity.ToTable("ChildUser");

                entity.HasIndex(e => e.Dob, "IX_ChildUser_DoB")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.FirstName, "IX_ChildUser_FirstName")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsActive, "IX_ChildUser_IsActive")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsDeleted, "IX_ChildUser_IsDeleted")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastName, "IX_ChildUser_LastName")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Dob).HasColumnName("DOB");

                entity.Property(e => e.FirstName).HasMaxLength(256);

                entity.Property(e => e.FirstNameAndLastName)
                    .HasMaxLength(513)
                    .HasComputedColumnSql("((coalesce([FirstName],'')+' ')+coalesce([LastName],''))", true);

                entity.Property(e => e.Gender)
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.LastName).HasMaxLength(256);

                entity.Property(e => e.MiddleNames).HasMaxLength(100);

                entity.HasOne(d => d.Parent)
                    .WithMany(p => p.ChildUsers)
                    .HasForeignKey(d => d.ParentId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ChildUser_User");
            });

            modelBuilder.Entity<CustomEntity>(entity =>
            {
                entity.ToTable("CustomEntity");

                entity.HasIndex(e => e.Created, "IX_CustomEntity_Created")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.CreatedById, "IX_CustomEntity_CreatedById")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsStrictEntity, "IX_CustomEntity_IsStrictEntity")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsSystemEntity, "IX_CustomEntity_IsSystemEntity")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModified, "IX_CustomEntity_LastModified")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModifiedById, "IX_CustomEntity_LastModifiedById")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.DefaultEntityName).HasMaxLength(256);

                entity.Property(e => e.Description).HasMaxLength(256);

                entity.Property(e => e.DisplayEntityName).HasMaxLength(256);

                entity.Property(e => e.IsSystemEntity)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);
                entity.HasOne(d => d.CreatedBy)
                    .WithMany(p => p.CustomEntityCreatedBies)
                    .HasForeignKey(d => d.CreatedById);

                entity.HasOne(d => d.LastModifiedBy)
                    .WithMany(p => p.CustomEntityLastModifiedBies)
                    .HasForeignKey(d => d.LastModifiedById);
            });

            modelBuilder.Entity<DataType>(entity =>
            {
                entity.ToTable("DataType");

                entity.HasIndex(e => e.Created, "IX_DataType_Created")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.CreatedById, "IX_DataType_CreatedById")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModified, "IX_DataType_LastModified")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModifiedById, "IX_DataType_LastModifiedById")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Alias)
                    .HasMaxLength(100)
                    .IsFixedLength();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Description).HasMaxLength(1000);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Name).HasMaxLength(100);

                entity.HasOne(d => d.CreatedBy)
                    .WithMany(p => p.DataTypeCreatedBies)
                    .HasForeignKey(d => d.CreatedById);

                entity.HasOne(d => d.LastModifiedBy)
                    .WithMany(p => p.DataTypeLastModifiedBies)
                    .HasForeignKey(d => d.LastModifiedById);
            });

            modelBuilder.Entity<DatabaseVersion>(entity =>
            {
                entity.ToTable("DatabaseVersion");

                entity.Property(e => e.Id).HasDefaultValueSql("(newid())");

                entity.Property(e => e.CreatedDate).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.VersionLabel).HasMaxLength(256);
            });

            modelBuilder.Entity<RefreshToken>(entity =>
            {
                entity.ToTable("RefreshToken");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.JwtId).HasMaxLength(128);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.RoleName).HasMaxLength(256);

                entity.Property(e => e.Token).HasMaxLength(256);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.RefreshTokens)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull);
            });

            modelBuilder.Entity<SettingEmail>(entity =>
            {
                entity.ToTable("SettingEmail");

                entity.HasIndex(e => e.Created, "IX_SettingEmail_Created")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.CreatedById, "IX_SettingEmail_CreatedById")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModified, "IX_SettingEmail_LastModified")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModifiedById, "IX_SettingEmail_LastModifiedById")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Description).HasMaxLength(1000);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Name).HasMaxLength(128);

                entity.Property(e => e.Value).HasMaxLength(500);

                entity.HasOne(d => d.CreatedBy)
                    .WithMany(p => p.SettingEmailCreatedBies)
                    .HasForeignKey(d => d.CreatedById);

                entity.HasOne(d => d.SettingEmailDataType)
                    .WithMany(p => p.SettingEmails)
                    .HasForeignKey(d => d.DataType)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_SettingEmail_DataType");

                entity.HasOne(d => d.LastModifiedBy)
                    .WithMany(p => p.SettingEmailLastModifiedBies)
                    .HasForeignKey(d => d.LastModifiedById);
            });

            modelBuilder.Entity<SettingGeneral>(entity =>
            {
                entity.ToTable("SettingGeneral");

                entity.HasIndex(e => e.Created, "IX_SettingGeneral_Created")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.CreatedById, "IX_SettingGeneral_CreatedById")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModified, "IX_SettingGeneral_LastModified")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModifiedById, "IX_SettingGeneral_LastModifiedById")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Description).HasMaxLength(1000);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Name).HasMaxLength(128);

                entity.Property(e => e.Value).HasMaxLength(500);

                entity.HasOne(d => d.CreatedBy)
                    .WithMany(p => p.SettingGeneralCreatedBies)
                    .HasForeignKey(d => d.CreatedById);

                entity.HasOne(d => d.SettingGeneralDataType)
                    .WithMany(p => p.SettingGenerals)
                    .HasForeignKey(d => d.DataType)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_SettingGeneral_DataType");

                entity.HasOne(d => d.LastModifiedBy)
                    .WithMany(p => p.SettingGeneralLastModifiedBies)
                    .HasForeignKey(d => d.LastModifiedById);
            });

            modelBuilder.Entity<SettingSecurityToken>(entity =>
            {
                entity.ToTable("SettingSecurityToken");

                entity.HasIndex(e => e.Created, "IX_SettingSecurityToken_Created")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.CreatedById, "IX_SettingSecurityToken_CreatedById")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModified, "IX_SettingSecurityToken_LastModified")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModifiedById, "IX_SettingSecurityToken_LastModifiedById")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Description).HasMaxLength(1000);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Name).HasMaxLength(128);

                entity.Property(e => e.Value).HasMaxLength(500);

                entity.HasOne(d => d.CreatedBy)
                    .WithMany(p => p.SettingSecurityTokenCreatedBies)
                    .HasForeignKey(d => d.CreatedById);

                entity.HasOne(d => d.SettingSecurityTokenDataType)
                    .WithMany(p => p.SettingSecurityTokens)
                    .HasForeignKey(d => d.DataType)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_SettingSecurityToken_DataType");

                entity.HasOne(d => d.LastModifiedBy)
                    .WithMany(p => p.SettingSecurityTokenLastModifiedBies)
                    .HasForeignKey(d => d.LastModifiedById);
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("User");

                entity.HasIndex(e => e.Id, "IX_User_AspNetUsers_Id")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.Created, "IX_User_Created")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.CreatedById, "IX_User_CreatedById")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.Dob, "IX_User_DoB")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.FirstName, "IX_User_FirstName")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsActive, "IX_User_IsActive")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsDeleted, "IX_User_IsDeleted")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModified, "IX_User_LastModified")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastModifiedById, "IX_User_LastModifiedById")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.LastName, "IX_User_LastName")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Dob).HasColumnName("DOB");

                entity.Property(e => e.FirstName).HasMaxLength(256);

                entity.Property(e => e.FirstNameAndLastName)
                    .HasMaxLength(513)
                    .HasComputedColumnSql("((coalesce([FirstName],'')+' ')+coalesce([LastName],''))", true);

                entity.Property(e => e.Gender)
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.LastName).HasMaxLength(256);

                entity.Property(e => e.MiddleNames).HasMaxLength(100);

                entity.Property(e => e.Title).HasMaxLength(10);

                entity.Property(e => e.Type).HasComment("The user type to differentiate entitlements, user type can be Domestic or International. (maybe more in the future?)");

                entity.HasOne(d => d.AspNetUsers)
                    .WithOne(p => p.User)
                    .HasForeignKey<User>(d => d.Id)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Users_AspNetUsers_UserId_Id");
            });

            modelBuilder.Entity<UserAddress>(entity =>
            {
                entity.ToTable("UserAddress");

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Address1).HasMaxLength(500);

                entity.Property(e => e.Address2).HasMaxLength(500);

                entity.Property(e => e.Country).HasMaxLength(100);

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Mobile).HasMaxLength(50);

                entity.Property(e => e.PostalAddress1).HasMaxLength(500);

                entity.Property(e => e.PostalAddress2).HasMaxLength(500);

                entity.Property(e => e.PostalCountry).HasMaxLength(100);

                entity.Property(e => e.PostalPostcode).HasMaxLength(10);

                entity.Property(e => e.PostalState).HasMaxLength(100);

                entity.Property(e => e.PostalSuburb).HasMaxLength(250);

                entity.Property(e => e.Postcode).HasMaxLength(10);

                entity.Property(e => e.State).HasMaxLength(100);

                entity.Property(e => e.Suburb).HasMaxLength(250);

                entity.HasOne(d => d.CreatedBy)
                    .WithMany(p => p.UserAddressCreatedBies)
                    .HasForeignKey(d => d.CreatedById);

                entity.HasOne(d => d.LastModifiedBy)
                    .WithMany(p => p.UserAddressLastModifiedBies)
                    .HasForeignKey(d => d.LastModifiedById);

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserAddressUsers)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull);
            });

            modelBuilder.Entity<Vaccine>(entity =>
            {
                entity.ToTable("Vaccine");

                entity.HasIndex(e => e.Code, "IX_Vaccine_Code")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsActive, "IX_Vaccine_IsActive")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsDeleted, "IX_Vaccine_IsDeleted")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.Name, "IX_Vaccine_Name")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Code).HasMaxLength(256);

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Description).HasMaxLength(512);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Name).HasMaxLength(256);

                entity.Property(e => e.Notes).HasMaxLength(512);

                entity.Property(e => e.Version).HasMaxLength(50);

                entity.HasOne(d => d.VaccineType)
                    .WithMany(p => p.Vaccines)
                    .HasForeignKey(d => d.VaccineTypeId);
            });

            modelBuilder.Entity<VaccineType>(entity =>
            {
                entity.ToTable("VaccineType");

                entity.HasIndex(e => e.IsActive, "IX_VaccineType_IsActive")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.IsDeleted, "IX_VaccineType_IsDeleted")
                    .HasFillFactor(90);

                entity.HasIndex(e => e.Name, "IX_VaccineType_Name")
                    .HasFillFactor(90);

                entity.Property(e => e.Id).ValueGeneratedNever();

                entity.Property(e => e.Created).HasDefaultValueSql("(sysdatetimeoffset())");

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Description).HasMaxLength(512);

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.Name).HasMaxLength(256);

                entity.Property(e => e.Notes).HasMaxLength(512);
            });

            modelBuilder.Entity<VwUser>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("vw_Users");

                entity.Property(e => e.Address1).HasMaxLength(500);

                entity.Property(e => e.Address2).HasMaxLength(500);

                entity.Property(e => e.Country).HasMaxLength(100);

                entity.Property(e => e.CreatedByName).HasMaxLength(256);

                entity.Property(e => e.Dob).HasColumnName("DOB");

                entity.Property(e => e.Email).HasMaxLength(256);

                entity.Property(e => e.FirstName).HasMaxLength(256);

                entity.Property(e => e.FirstNameAndLastName).HasMaxLength(513);

                entity.Property(e => e.Gender)
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.LastModifiedByName).HasMaxLength(256);

                entity.Property(e => e.LastName).HasMaxLength(256);

                entity.Property(e => e.MiddleNames).HasMaxLength(100);

                entity.Property(e => e.Mobile).HasMaxLength(50);

                entity.Property(e => e.PostalAddress1).HasMaxLength(500);

                entity.Property(e => e.PostalAddress2).HasMaxLength(500);

                entity.Property(e => e.PostalCountry).HasMaxLength(100);

                entity.Property(e => e.PostalPostcode).HasMaxLength(10);

                entity.Property(e => e.PostalState).HasMaxLength(100);

                entity.Property(e => e.PostalSuburb).HasMaxLength(250);

                entity.Property(e => e.Postcode).HasMaxLength(10);

                entity.Property(e => e.State).HasMaxLength(100);

                entity.Property(e => e.Suburb).HasMaxLength(250);

                entity.Property(e => e.Title).HasMaxLength(10);

                entity.Property(e => e.Username).HasMaxLength(256);
            });

            modelBuilder.ApplyBaseEntityConfiguration();

            OnModelCreatingPartial(modelBuilder);
        }
    }
}