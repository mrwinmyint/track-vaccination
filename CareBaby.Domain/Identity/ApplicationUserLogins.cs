using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Text;

namespace CareBaby.Domain.Identity
{
    public class ApplicationUserLogins : IdentityUserLogin<Guid>
    {
        public ApplicationUserLogins() : base()
        {
        }

        public virtual Identity.ApplicationUser User { get; set; }
    }
}
