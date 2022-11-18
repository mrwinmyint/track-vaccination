using CareBaby.Domain.Common;
using CareBaby.Domain.Entities;
using CareBaby.Infrastructure.Persistence;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Infrastructure
{
    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        private readonly ApplicationDbContext _dbContext;
        private readonly IServiceProvider _provider;
        //private IAsyncRepository<User> _userRepository;

        public UnitOfWork(ApplicationDbContext dbContext,
            IServiceProvider provider)
        {
            _dbContext = dbContext;
            _provider = provider;
        }

        public T AsyncRepository<T>(ref T member)
        {
            return member ??= _provider.GetService<T>();
        }

        //public IAsyncRepository<User> UserRepository => AsyncRepository(ref _userRepository);

        public async Task<int> CommitAsync()
        {
            return await _dbContext.SaveChangesAsync();
        }

        public void Dispose()
        {
            _dbContext.Dispose();
        }
    }
}
