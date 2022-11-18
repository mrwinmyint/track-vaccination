using Microsoft.AspNetCore.Identity;

namespace CareBaby.Domain.Identity
{
    public partial class ApplicationRole : IdentityRole<Guid>
    {
        public ApplicationRole() : base()
        {
            ApplicationUserRoles = new HashSet<ApplicationUserRoles>();
        }

        public ApplicationRole(string name) : base(name)
        {
            ApplicationUserRoles = new HashSet<ApplicationUserRoles>();
        }

        public virtual ICollection<ApplicationUserRoles> ApplicationUserRoles { get; set; }
    }
}