using System;
using System.Collections.Generic;

namespace CareBaby.Domain.Identity
{
    public partial class AspNetUserRoles
    {
        public Guid UserId { get; set; }
        public Guid RoleId { get; set; }

        public virtual AspNetRole? Role { get; set; }
        public virtual AspNetUser? User { get; set; }
    }
}

