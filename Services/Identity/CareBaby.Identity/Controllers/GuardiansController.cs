using CareBaby.Application.ParentUsers.Queries.GetParents;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.OData.Routing.Controllers;

namespace CareBaby.Identity.Controllers
{
    public class GuardiansController : BaseODataController
    {
        private readonly ILogger<GuardiansController> _logger;

        public GuardiansController(ILogger<GuardiansController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public virtual async Task<ParentsVm> Get()
        {
            return await Mediator.Send(new GetParentsQuery());
        }
    }
}