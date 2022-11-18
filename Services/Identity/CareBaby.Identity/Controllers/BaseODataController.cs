using CareBaby.Application.Common.Contracts.Infrastructure;
using MediatR;
using Microsoft.AspNetCore.OData.Routing.Controllers;

namespace CareBaby.Identity.Controllers
{
    public abstract class BaseODataController : ODataController
    {
        private ISender _mediator = null!;
        private IHttpService _httpService = null!;

        protected ISender Mediator => _mediator ??= HttpContext.RequestServices.GetRequiredService<ISender>();        
        protected IHttpService HttpService => _httpService ??= HttpContext.RequestServices.GetRequiredService<IHttpService>();
    }
}