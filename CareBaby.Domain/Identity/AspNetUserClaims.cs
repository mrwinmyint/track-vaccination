using System;
using System.Collections.Generic;
using System.Text;

namespace CareBaby.Domain.Identity
{
    public partial class AspNetUserClaims
    {
        public int Id { get; set; }
        public Guid UserId { get; set; }
        public string? ClaimType { get; set; }
        public string? ClaimValue { get; set; }

        public virtual AspNetUser? User { get; set; }
    }
}
