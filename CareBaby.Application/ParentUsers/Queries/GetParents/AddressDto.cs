using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Application.ParentUsers.Queries.GetParents
{
    public class AddressDto
    {
        public string Address { get; set; }
        public string Suburb { get; set; }
        public string Postcode { get; set; }    
        public string State { get; set; }
        public string Country { get; set; }
    }
}
