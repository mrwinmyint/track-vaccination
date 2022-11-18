using CareBaby.Application.Common.Contracts.Infrastructure;
using System.Security.Claims;

namespace CareBaby.Identity.Services;

public class CurrentUserService : ICurrentUserService
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public CurrentUserService(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    //public Guid? UserId => _httpContextAccessor.HttpContext == null ||
    //    _httpContextAccessor.HttpContext.User == null ?
    //        (Guid?)null : 
    //        new Guid(_httpContextAccessor.HttpContext?.User?.FindFirstValue(ClaimTypes.NameIdentifier));

    private ClaimsPrincipal User => _httpContextAccessor.HttpContext?.User;

    public Guid? UserId => User != null && User.Identity.IsAuthenticated ? Guid.Parse(User.FindFirstValue(ClaimTypes.PrimarySid)) : (Guid?)null;

    public bool IsAuthenticated => User != null && User.Identity.IsAuthenticated;

}
