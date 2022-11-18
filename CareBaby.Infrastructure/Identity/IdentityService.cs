using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Common.Models;
using CareBaby.Application.Settings.Security.Queries;
using CareBaby.Application.UserAccount.Commands.Authenticate;
using CareBaby.Application.UserAccount.Commands.SelectRole;
using CareBaby.Domain.Enums;
using CareBaby.Domain.Identity;
using CareBaby.Infrastructure.Extensions;
using MediatR;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json.Linq;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace CareBaby.Infrastructure.Identity
{
    public class IdentityService : IIdentityService
    {
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly SignInManager<ApplicationUser> _signInManager;
        private readonly IUserClaimsPrincipalFactory<ApplicationUser> _userClaimsPrincipalFactory;
        private readonly IAuthorizationService _authorizationService;
        private readonly IMediator _mediator;

        public IdentityService(UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            IUserClaimsPrincipalFactory<ApplicationUser> userClaimsPrincipalFactory,
            IAuthorizationService authorizationService,
            IMediator mediator)
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _authorizationService = authorizationService;
            _userClaimsPrincipalFactory = userClaimsPrincipalFactory;
            _mediator = mediator;
        }

        public async Task<IEnumerable<string>> GetRoles(string userName)
        {
            var user = await _userManager.Users.FirstAsync(u => u.UserName == userName);
            var roles = await _userManager.GetRolesAsync(user);
            return roles;
        }

        public async Task<string> GetUserNameAsync(Guid userId)
        {
            var user = await _userManager.Users.FirstAsync(u => u.Id == userId);

            return user.UserName;
        }

        public async Task<ApplicationUser> GetUserByEmailAsync(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);

            return user;
        }

        public async Task<ApplicationUser> GetUserByIdAsync(Guid userId)
        {
            var user = await _userManager.Users.FirstAsync(u => u.Id == userId);

            return user;
        }

        public async Task<bool> IsInRoleAsync(Guid userId, string role)
        {
            var user = _userManager.Users.SingleOrDefault(u => u.Id == userId);

            return user != null && await _userManager.IsInRoleAsync(user, role);
        }

        public async Task<Result> AddToRoleAsync(Guid userId, string role)
        {
            var user = _userManager.Users.SingleOrDefault(u => u.Id == userId);

            return user != null ? await AddToRoleAsync(user, role) : Result.Success();
        }

        private async Task<Result> AddToRoleAsync(ApplicationUser user, string role)
        {
            var result = await _userManager.AddToRoleAsync(user, role);

            return result.ToApplicationResult();
        }

#pragma warning disable CS8613 // Nullability of reference types in return type doesn't match implicitly implemented member.

        public async Task<string?> GenerateEmailConfirmationTokenAsync(Guid userId)
#pragma warning restore CS8613 // Nullability of reference types in return type doesn't match implicitly implemented member.
        {
            var user = _userManager.Users.SingleOrDefault(u => u.Id == userId);

            return user != null ? await GenerateEmailConfirmationTokenAsync(user) : null;
        }

        private async Task<string> GenerateEmailConfirmationTokenAsync(ApplicationUser user)
        {
            var result = await _userManager.GenerateEmailConfirmationTokenAsync(user);

            return result;
        }

        public async Task<bool> AuthorizeAsync(Guid userId, string policyName)
        {
            var user = _userManager.Users.SingleOrDefault(u => u.Id == userId);

            if (user == null)
            {
                return false;
            }

            var principal = await _userClaimsPrincipalFactory.CreateAsync(user);

            var result = await _authorizationService.AuthorizeAsync(principal, policyName);

            return result.Succeeded;
        }

        public async Task<Result> DeleteUserAsync(Guid userId)
        {
            var user = _userManager.Users.SingleOrDefault(u => u.Id == userId);

            return user != null ? await DeleteUserAsync(user) : Result.Success();
        }

        private async Task<Result> DeleteUserAsync(ApplicationUser user)
        {
            var result = await _userManager.DeleteAsync(user);

            return result.ToApplicationResult();
        }

        public async Task<(Result Result, Guid UserId)> CreateUserAsync(string userName,
            string password,
            string firstName,
            string lastName)
        {
            var user = new ApplicationUser
            {
                Id = Guid.NewGuid(),
                UserName = userName,
                Email = userName,
                User = new Domain.Entities.User()
                {
                    FirstName = firstName,
                    LastName = lastName,
                    Type = (short)UserType.Guardian.Id,
                    IsActive = true,
                    IsDeleted = false,
                    Created = DateTimeOffset.UtcNow,
                }
            };

            var result = await _userManager.CreateAsync(user, password);

            return (result.ToApplicationResult(), user.Id);
        }

        public async Task<Result> ConfirmEmailAsync(string email, string token)
        {
            var user = await GetUserByEmailAsync(email);
            if (user == null)
            {
                return Result.Failure(new List<string>() { $"{email} not found." });
            }

            var result = await _userManager.ConfirmEmailAsync(user, token);
            return result.ToApplicationResult();
        }

        public async Task<AuthenticateCommandResponse<Guid?>> AuthenticateAsync(string userName,
            string password,
            bool isPersistent)
        {
            var user = _userManager.Users.SingleOrDefault(u => u.UserName == userName);

            return user != null ?
                await AuthenticateAsync(user,
                    password,
                    isPersistent) :
                AuthenticateCommandResponse<Guid?>.Failure(ValidationError.UserDoesNotExist);
        }

        private async Task<AuthenticateCommandResponse<Guid?>> AuthenticateAsync(ApplicationUser user,
            string password,
            bool isPersistent)
        {
            // verify SignInResult
            var checkPasswordSignIn = await _signInManager.CheckPasswordSignInAsync(user, 
                password,
                true);

            if (checkPasswordSignIn.IsNotAllowed)
            {
                return AuthenticateCommandResponse<Guid?>.Failure(ValidationError.SignInIsNotAllowedError, true);
            }

            if (checkPasswordSignIn.IsLockedOut)
            {
                return AuthenticateCommandResponse<Guid?>.Failure(ValidationError.SignInIsLockedOutError, signInIsLockedOut: true);
            }

            if (checkPasswordSignIn.RequiresTwoFactor)
            {
                return AuthenticateCommandResponse<Guid?>.Failure(ValidationError.SignInRequiresTwoFactorError, signInRequiresTwoFactor: true);
            }

            if (checkPasswordSignIn == SignInResult.Failed)
            {
                return AuthenticateCommandResponse<Guid?>.Failure(ValidationError.InvalidEmailOrPassword);
            }

            // get UserRoles
            var userRoles = await GetRoles(user.UserName);
            if (!userRoles.Any())
            {
                return AuthenticateCommandResponse<Guid?>.Failure(ValidationError.UserDoesNotHaveValidRole);
            }
            else if (userRoles.Count() > 1)
            {
                // get token for role selection because the specified user has multiple roles
                var token = await _userManager.GenerateUserTokenAsync(user,
                                                                     "RoleSelectionTokenProvider",
                                                                     "roleselection-auth");

                // populate RoleSelection object
                var roleSelection = new RoleSelection(true,
                    token,
                    userRoles,
                    user.Email);

                return AuthenticateCommandResponse<Guid?>.Success(false, roleSelection, null);
            }

            var role = userRoles.Single();

            var jwtSecurityToken = await GenerateJwtToken(user, role);

            if (jwtSecurityToken == null)
            {
                return AuthenticateCommandResponse<Guid?>.Failure(ValidationError.RoleDoesNotMatch);
            }

            var jwtToken = jwtSecurityToken.AsJwtToken();

            // also add cookie auth for Swagger Access
            await _signInManager.SignInWithClaimsAsync(
                user,
                new AuthenticationProperties
                {
                    IsPersistent = isPersistent,
                    AllowRefresh = true,
                    ExpiresUtc = DateTime.UtcNow.AddDays(1)
                },
                jwtSecurityToken.Claims);

            // TODO: need to add refresh token

            return AuthenticateCommandResponse<Guid?>.Success(true, null, jwtToken);
        }

        private async Task<JwtSecurityToken> GenerateJwtToken(ApplicationUser user, string role)
        {
            // generate token that is valid for 3 hours
            var userRoles = await GetRoles(user.UserName);
            var securityTokenSettings = await GetSecurityTokenSettings();

            // check the provided role exists in the store for the specified user
            if (!userRoles.Contains(role))
            {
                // TODO: need to provide error message for provided role does not exist in the store for the specified user
                return null;
            }

            var authClaims = new[]
            {
                new Claim(ClaimTypes.Name, user.UserName),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                // just add logged in role in the claim
                new Claim(ClaimTypes.Role, role)
            };

            var authSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(securityTokenSettings.Secret));

            var token = new JwtSecurityToken(issuer: securityTokenSettings.Issuer,
                                             audience: securityTokenSettings.Audience,
                                             claims: authClaims,
                                             expires: DateTime.UtcNow.AddMinutes(securityTokenSettings.AccessTokenExpiryMinutes),
                                             signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256));

            return token;
        }

        private async Task<SecurityTokenSettingDetailsDto> GetSecurityTokenSettings()
        {
            var securityTokenSettings = await _mediator.Send(new GetSecurityTokenSettingsQuery());
            return securityTokenSettings;
        }

        public async Task<SelectRoleCommandResponse<Guid?>> VerifyRoleSelectionTokenAsync(string userName,
            string role,
            string roleSelectionToken)
        {
            var user = _userManager.Users.SingleOrDefault(u => u.UserName == userName);

            return user != null ?
                await VerifyRoleSelectionTokenAsync(user,
                    role,
                    roleSelectionToken) :
                SelectRoleCommandResponse<Guid?>.Failure(ValidationError.UserDoesNotExist);
        }

        private async Task<SelectRoleCommandResponse<Guid?>> VerifyRoleSelectionTokenAsync(ApplicationUser user,
            string role,
            string roleSelectionToken)
        {
            var isRoleSelectionTokenValid = await _userManager.VerifyUserTokenAsync(user, "RoleSelectionTokenProvider", "roleselection-auth", roleSelectionToken);
            if (isRoleSelectionTokenValid)
            {
                var jwtSecurityToken = await GenerateJwtToken(user, role);

                if (jwtSecurityToken == null)
                {
                    return SelectRoleCommandResponse<Guid?>.Failure(ValidationError.RoleDoesNotMatch);
                }

                var jwtToken = jwtSecurityToken.AsJwtToken();

                return SelectRoleCommandResponse<Guid?>.Success(jwtToken);
            }
            else
            {
                return SelectRoleCommandResponse<Guid?>.Failure(ValidationError.InvalidRoleSelectionToken);
            }
        }
    }
}