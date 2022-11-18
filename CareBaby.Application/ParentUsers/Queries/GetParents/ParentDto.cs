using CareBaby.Application.Common.Mappings;
using CareBaby.Application.Common.Models;
using CareBaby.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.ParentUsers.Queries.GetParents;

public class ParentDto : BaseUserModel, IMapFrom<User>
{
    public ParentDto()
    {
        Childern = new List<ChildDto>();
        Address = new AddressDto();
    }
    public Guid Id { get; set; }
    public string Email { get; set; }
    public AddressDto Address { get; set; }
    public IList<ChildDto> Childern { get; set; }
}
