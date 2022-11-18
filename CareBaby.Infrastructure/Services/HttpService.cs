using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.UserAccount.Commands.Authenticate;
using Microsoft.AspNetCore.Http;

namespace CareBaby.Infrastructure.Services;

public class HttpService : IHttpService
{
    public void SetTokenCookie(HttpResponse response, JwtToken jwtToken)
    {
        var cookieOptions = new CookieOptions
        {
            HttpOnly = true,
            Expires = jwtToken.RefreshTokenExpiration
        };
        response.Cookies.Append("refreshToken", jwtToken.RefreshToken, cookieOptions);
    }
}