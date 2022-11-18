using System;
using System.Collections.Generic;
using System.Text;

namespace CareBaby.Domain.Identity
{
    public partial class AspNetRoleClaims
    {
        public int Id { get; set; }
        public string? ClaimType { get; set; }
        public string? ClaimValue { get; set; }
        public Guid RoleId { get; set; }

        public virtual AspNetRole? Role { get; set; }
    }
}
