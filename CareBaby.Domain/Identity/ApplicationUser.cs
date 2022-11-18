using CareBaby.Domain.Entities;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace CareBaby.Domain.Identity
{
    public partial class ApplicationUser : IdentityUser<Guid>
    {
        public ApplicationUser() : base()
        {
            ApplicationUserRoles = new HashSet<ApplicationUserRoles>();
            RefreshTokens = new HashSet<RefreshToken>();
        }

        public virtual User User { get; set; }
        public virtual ICollection<ApplicationUserRoles> ApplicationUserRoles { get; set; }
        public virtual ICollection<RefreshToken> RefreshTokens { get; set; }
    }
}
