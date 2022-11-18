using CareBaby.Application.Common.Mappings;
using CareBaby.Application.Common.Models;
using CareBaby.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.ParentUsers.Queries.GetParents;
public class ChildDto : BaseUserModel, IMapFrom<ChildUser>
{
    public Guid Id { get; set; }
    public Guid ParentId { get; set; }
    public string Gender { get; set; }
    public DateTimeOffset? Dob { get; set; }
    public string MiddleNames { get; set; }
    public string FirstNameAndLastName { get; set; }
}