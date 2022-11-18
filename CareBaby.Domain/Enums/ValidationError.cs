using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Domain.Enums;

public class ValidationError : Enumeration
{
    public static ValidationError UserAuthenticatingError = new(1000, "There was an error while authenticating a user");
    public static ValidationError UserDoesNotExist = new(1001, "Specified user does not exist");
    public static ValidationError UserDoesNotHaveValidRole = new(1002, "Specified user does not have valid role");
    public static ValidationError RoleDoesNotMatch = new (1003, "Specified role does not match with the user role");
    public static ValidationError InvalidEmailOrPassword = new(1004, "Invalid email or password");
    public static ValidationError EmailNotFound = new(1005, "Email not found");
    public static ValidationError SignInIsNotAllowedError = new(1006, "The user is not allowed to sign-in");
    public static ValidationError SignInIsLockedOutError = new(1007, "The user is locked out");
    public static ValidationError SignInRequiresTwoFactorError = new(1008, "The user attempting to sign-in requires two factor authentication");
    public static ValidationError InvalidRoleSelectionToken = new(1009, "Invalid role selection token was provided");

    public ValidationError(int id, string name)
        : base(id, name)
    {
    }
}
