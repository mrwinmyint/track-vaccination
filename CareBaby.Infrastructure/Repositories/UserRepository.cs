using CareBaby.Application.Common.Contracts.Persistence;
using CareBaby.Domain.Common;
using CareBaby.Domain.Entities;
using CareBaby.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Infrastructure.Repositories
{
    public class UserRepository 
    {
        //public UserRepository(ApplicationDbContext context) : base(context)
        //{
        //}

        //public async Task<IEnumerable<User>> GetUserByUserName(string userName)
        //{
        //    var userList = await _dbContext.Users
        //                        .Where(u => u.AspNetUsers.UserName == userName)
        //                        .ToListAsync();
        //    return userList;
        //}
    }
}
