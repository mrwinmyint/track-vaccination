using CareBaby.Domain.Common;
using CareBaby.Domain.Entities;

namespace CareBaby.Application.Common.Contracts.Persistence
{
    public interface IUserRepository
    {
        Task<IEnumerable<User>> GetUserByUserName(string userName);
    }
}