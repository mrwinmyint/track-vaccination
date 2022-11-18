using CareBaby.Application.UserAccount.Commands.Authenticate;
using Microsoft.AspNetCore.Http;

namespace CareBaby.Application.Common.Contracts.Infrastructure;

public interface IHttpService
{
    void SetTokenCookie(HttpResponse response, JwtToken jwtToken);
}