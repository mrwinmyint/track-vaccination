using CareBaby.Application.UserAccount.Commands.Authenticate;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Infrastructure.Extensions;
public static class SecurityTokenExtensions
{
    public static JwtToken AsJwtToken(this JwtSecurityToken jwtSecurityToken)
    {
        var customClaims = jwtSecurityToken.Claims.Select(x => new CustomClaim()
        {
            Subject = x.Subject,
            Type = x.Type,
            Value = x.Value,
        }).ToArray();

        var jwtToken = new JwtToken(new JwtSecurityTokenHandler().WriteToken(jwtSecurityToken),
            jwtSecurityToken.ValidTo,
            customClaims,
            RandomString(35) + Guid.NewGuid(),
            DateTimeOffset.UtcNow.AddHours(24)); // TODO: use refresh token expiry

        return jwtToken;
    }

    private static string RandomString(int length)
    {
        var random = new Random();
        var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        return new string(Enumerable.Repeat(chars, length)
            .Select(x => x[random.Next(x.Length)]).ToArray());
    }
}
