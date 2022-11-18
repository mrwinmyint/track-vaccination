namespace CareBaby.Domain.Identity
{
    public partial class AspNetRole
    {
        public AspNetRole()
        {
            Roles = new HashSet<AspNetUserRoles>();
        }

        public Guid Id { get; set; }
        public string Name { get; set; }
        public string NormalizedName { get; set; }
        public string ConcurrencyStamp { get; set; }
        public virtual ICollection<AspNetUserRoles> Roles { get; set; }
    }
}