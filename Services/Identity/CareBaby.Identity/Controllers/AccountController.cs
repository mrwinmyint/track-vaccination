using CareBaby.Application.Common.Contracts.Infrastructure;
using CareBaby.Application.Common.Models;
using CareBaby.Application.UserAccount.Commands.Authenticate;
using CareBaby.Application.UserAccount.Commands.ConfirmEmail;
using CareBaby.Application.UserAccount.Commands.SignUp;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using static Microsoft.AspNetCore.Http.StatusCodes;

namespace CareBaby.Identity.Controllers
{
    public class AccountController : BaseODataController
    {
        
        [HttpPost]
        [AllowAnonymous]
        public virtual async Task<ActionResult<SignUpCommandResponse<Guid?>>> SignUp([FromBody] SignUpCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                return await Mediator.Send(command);
            }
            catch (Exception ex)
            {
                return StatusCode(Status500InternalServerError);
            }
        }

        /// <summary>
        /// Confirm email function
        /// </summary>
        /// <remark>
        /// *** use camal case in body request (as below) ***
        /// {
        ///     "email": "abc@email.com",
        ///     "token": "CfDJ8P%2B1tSBdvuJBgk4qF589UUYUZKBaKW3zIEBhnNhliQ%2BjgDlaBE%2Br5O5pU1kz7LRdnguQdj1oUZSbbY4zOs%2F6jGEERzAkEkotN6%2Bo%2BiI5lFewfGzOHm7Oleze3%2B2p21xGurmCRDy5oGZAUUal4vb0adNSqdCbEZ8aTkWawno2Cc8eIYj2SjfyKAWDOeR71XubnhNIPmFatwXvV23ynBh%2FHKFko2nTSiM%2FfmC9TPs8o2ds18fp32xmdDb2%2FpFOqZlA9A%3D%3D"
        /// }
        /// </remark>
        /// <param name="request">ConfirmEmailCommand (in body request)</param>
        /// <returns>BaseCommandResponse<Guid?> when it is Ok, otherwise error</returns>
        [HttpPost]
        [AllowAnonymous]
        public virtual async Task<ActionResult<BaseCommandResponse<Guid?>>> ConfirmEmail([FromBody] ConfirmEmailCommand command)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                return await Mediator.Send(command);
            }
            catch (Exception ex)
            {
                return StatusCode(Status500InternalServerError);
            }
        }

        [HttpPost]
        [AllowAnonymous]
        public virtual async Task<ActionResult<AuthenticateCommandResponse<Guid?>>> SignIn([FromBody] AuthenticateCommand authCommand)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                // TODO: apply refresh token in Cookie

                var authenticateCommandResponse = await Mediator.Send(authCommand);

                if (authenticateCommandResponse.JwtToken != null)
                {
                    HttpService.SetTokenCookie(Response, authenticateCommandResponse.JwtToken);
                }

                return authenticateCommandResponse;
            }
            catch (Exception ex)
            {
                return StatusCode(Status500InternalServerError);
            }
        }
    }
}