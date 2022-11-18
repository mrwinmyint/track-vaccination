using System;
using System.Collections.Generic;
using System.Text;

namespace CareBaby.Domain.Identity
{
    public partial class ApplicationUserRoles : Microsoft.AspNetCore.Identity.IdentityUserRole<Guid>
    {
        public ApplicationUserRoles() : base()
        {
        }

        public virtual ApplicationRole Role { get; set; }
        public virtual ApplicationUser User { get; set; }
    }
}
