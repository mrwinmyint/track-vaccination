using CareBaby.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace CareBaby.Application.Common.Contracts.Infrastructure
{
    public interface IApplicationDbContext
    {
        DbSet<ChildUser> ChildUsers { get; }
        DbSet<User> Users { get; }
        DbSet<SettingEmail> SettingEmails { get; }
        DbSet<SettingGeneral> SettingGenerals { get; }
        DbSet<SettingSecurityToken> SettingSecurityTokens { get; }

        Task<int> SaveChangesAsync(CancellationToken cancellationToken);
    }
}