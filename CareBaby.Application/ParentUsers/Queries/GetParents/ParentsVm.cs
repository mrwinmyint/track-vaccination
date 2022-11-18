using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.ParentUsers.Queries.GetParents;

public class ParentsVm
{
    public IList<ParentDto> Lists { get; set; } = new List<ParentDto>();
}
