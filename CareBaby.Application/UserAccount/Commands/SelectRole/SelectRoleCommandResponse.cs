using CareBaby.Application.Common.Models;
using CareBaby.Application.UserAccount.Commands.Authenticate;
using CareBaby.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.UserAccount.Commands.SelectRole;

public class SelectRoleCommandResponse<T> : BaseCommandResponse<T>
{
    public SelectRoleCommandResponse(IEnumerable<BaseError> errors,
        string message)
    {
        Succeeded = false;
        Errors = errors.Select(error => new BaseError() { Code = error.Code, Description = error.Description }).AsEnumerable();
        Message = message;
    }

    public SelectRoleCommandResponse(string message,
        JwtToken jwtToken)
    {
        Succeeded = true;
        Errors = null;
        Message = message;
        JwtToken = jwtToken;
    }

    public JwtToken JwtToken { get; set; } = null;

    public static SelectRoleCommandResponse<T> Success(JwtToken jwtToken)
    {
        var message = "The selected role has been verified successfully.";

        return new SelectRoleCommandResponse<T>(message, jwtToken);
    }

    public static SelectRoleCommandResponse<T> Failure(ValidationError error, string notes = null)
    {
        var errorDetails = new BaseError() { Code = error.Id.ToString(), Description = error.Name };
        var message = string.IsNullOrEmpty(notes) ? error.Name : notes;
        return new SelectRoleCommandResponse<T>(new List<BaseError>() { errorDetails }, message);
    }
}