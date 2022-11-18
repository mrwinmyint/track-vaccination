using CareBaby.Application.Common.Models;
using CareBaby.Domain.Enums;
using System.Security.Claims;

namespace CareBaby.Application.UserAccount.Commands.Authenticate;

public class AuthenticateCommandResponse<T> : BaseCommandResponse<T>
{
    internal AuthenticateCommandResponse(
        IEnumerable<BaseError> errors,
        string message,
        bool signInIsNotAllowed = false,
        bool signInIsLockedOut = false,
        bool signInRequiresTwoFactor = false)
    {
        Succeeded = false;
        Errors = errors.Select(error => new BaseError() { Code = error.Code, Description = error.Description }).AsEnumerable();
        Message = message;
        NotAllowed = signInIsNotAllowed;
        LockedOut = signInIsLockedOut;
        TwoFactorRequired = signInRequiresTwoFactor;
    }

    internal AuthenticateCommandResponse(string message,
        bool? isSingleRole,
        RoleSelection roleSelection,
        JwtToken jwtToken)
    {
        Succeeded = true;
        Errors = null;
        Message = message;
        IsSingleRole = isSingleRole;
        JwtToken = jwtToken;
        RoleSelection = roleSelection;
    }

    public bool? IsSingleRole { get; set; }
    public RoleSelection RoleSelection { get; set; } = null;
    public JwtToken JwtToken { get; set; } = null;
    public bool NotAllowed { get; set; } = false;
    public bool LockedOut { get; set; } = false;
    public bool TwoFactorRequired { get; set; } = false;

    public static AuthenticateCommandResponse<T> Success(bool isSingleRole,
        RoleSelection roleSelection,
        JwtToken jwtToken)
    {
        var message = "The user was authenticated successfully.";

        return new AuthenticateCommandResponse<T>(message,
            isSingleRole,
            roleSelection,
            jwtToken);
    }

    public static AuthenticateCommandResponse<T> Failure(ValidationError error,
        bool signInIsNotAllowed = false,
        bool signInIsLockedOut = false,
        bool signInRequiresTwoFactor = false,
        string notes = null)
    {
        var errorDetails = new BaseError() { Code = error.Id.ToString(), Description = error.Name };
        var message = string.IsNullOrEmpty(notes) ? error.Name : notes;
        return new AuthenticateCommandResponse<T>(new List<BaseError>() { errorDetails }, 
            message,
            signInIsNotAllowed,
            signInIsLockedOut,
            signInRequiresTwoFactor);
    }
}

public class RoleSelection
{
    public RoleSelection(bool requireRoleSelection,
        string token,
        IEnumerable<string> roles,
        string email)
    {
        RequireRoleSelection = requireRoleSelection;
        Token = token;
        Roles = roles;
        Email = email;
    }

    public bool RequireRoleSelection { get; set; }
    public string Token { get; set; }
    public IEnumerable<string> Roles { get; set; }
    public string Email { get; set; }
}

public class JwtToken
{
    public JwtToken(string token,
        DateTimeOffset expiration,
        IEnumerable<CustomClaim> claims,
        string refreshToken,
        DateTimeOffset refreshTokenExpiration)
    {
        Token = token;
        Expiration = expiration;
        Claims = claims;
        RefreshToken = refreshToken;
        RefreshTokenExpiration = refreshTokenExpiration;
    }

    public string Token { get; set; }

    /// <summary>
    /// Gets the 'value' of the 'expiration' claim { exp, 'value' } converted to a System.DateTime
    /// assuming 'value' is seconds since UnixEpoch (UTC 1970-01-01T0:0:0Z).
    /// </summary>
    /// <remarks>
    /// If the 'expiration' claim is not found, then System.DateTime.MinValue is returned.
    /// </remarks>
    public DateTimeOffset Expiration { get; set; }

    /// <summary>
    /// Gets the System.Security.Claims.Claim(s) for this token. If this is a JWE token,
    /// this property only returns the encrypted claims; the unencrypted claims should
    /// be read from the header seperately.
    /// </summary>
    /// <remarks>
    /// System.Security.Claims.Claim(s) returned will NOT have the System.Security.Claims.Claim.Type
    /// translated according to System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler.InboundClaimTypeMap
    /// </remarks>
    public IEnumerable<CustomClaim> Claims { get; set; }

    public string RefreshToken { get; set; }
    public DateTimeOffset RefreshTokenExpiration { get; set; }
}

public class CustomClaim
{
    public ClaimsIdentity? Subject { get; set; }
    public string Type { get; set; }
    public string Value { get; set; }
}