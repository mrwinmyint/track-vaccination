using CareBaby.Application.Common.Models;
using CareBaby.Application.UserAccount.Commands.Authenticate;
using CareBaby.Application.UserAccount.Commands.SelectRole;
using CareBaby.Domain.Identity;

namespace CareBaby.Application.Common.Contracts.Infrastructure
{
    public interface IIdentityService
    {
        Task<IEnumerable<string>> GetRoles(string userName);

        Task<ApplicationUser> GetUserByEmailAsync(string email);

        Task<ApplicationUser> GetUserByIdAsync(Guid userId);

        Task<string> GetUserNameAsync(Guid userId);

        Task<bool> IsInRoleAsync(Guid userId, string role);

        Task<Result> AddToRoleAsync(Guid userId, string role);

        Task<Result> ConfirmEmailAsync(string email, string token);

        Task<string?> GenerateEmailConfirmationTokenAsync(Guid userId);

        Task<bool> AuthorizeAsync(Guid userId, string policyName);

        Task<(Result Result, Guid UserId)> CreateUserAsync(string userName,
            string password,
            string firstName,
            string lastName);

        Task<Result> DeleteUserAsync(Guid userId);

        Task<AuthenticateCommandResponse<Guid?>> AuthenticateAsync(string userName, 
            string password,
            bool isPersistent);

        Task<SelectRoleCommandResponse<Guid?>> VerifyRoleSelectionTokenAsync(string userName,
            string role,
            string roleSelectionToken);
    }
}