using CareBaby.Application.Common.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.UserAccount.Commands.SignUp;

public class SignUpCommandResponse<T> : BaseCommandResponse<T>
{
    public string ConfirmationEmailToken { get; set; }
}
