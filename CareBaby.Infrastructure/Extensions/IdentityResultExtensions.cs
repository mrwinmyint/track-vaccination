using CareBaby.Application.Common.Models;
using Microsoft.AspNetCore.Identity;

namespace CareBaby.Infrastructure.Extensions;

public static class IdentityResultExtensions
{
    public static Result ToApplicationResult(this IdentityResult result)
    {
        return result.Succeeded ?
            Result.Success() :
            Result.Failure(result.Errors.Select(er => er.Description));
    }
}