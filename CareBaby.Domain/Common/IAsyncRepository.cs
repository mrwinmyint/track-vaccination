﻿using CareBaby.Domain.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace CareBaby.Domain.Common
{
    public interface IAsyncRepository<T> where T : EntityBase<Guid>, IAggregateRoot
    {
        Task<IReadOnlyList<T>> GetAllAsync();

        Task<IReadOnlyList<T>> GetAsync(Expression<Func<T, bool>> predicate);

        Task<IReadOnlyList<T>> GetAsync(Expression<Func<T, bool>>? predicate = null,
                                        Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
                                        string? includeString = null,
                                        bool disableTracking = true);

        Task<IReadOnlyList<T>> GetAsync(Expression<Func<T, bool>>? predicate = null,
                                        Func<IQueryable<T>, IOrderedQueryable<T>>? orderBy = null,
                                        List<Expression<Func<T, object>>>? includes = null,
                                        bool disableTracking = true);

        Task<IReadOnlyList<T>> GetAsync(ISpecification<T> spec);

        Task<T> GetByIdAsync(Guid id);

        Task<bool> ExistAsync(Guid Id);

        Task<T> AddAsync(T entity);
        Task UpdateAsync(T entity);
        Task DeleteAsync(T entity);

        Task<int> CountAsync(ISpecification<T> spec);

        Task<IEnumerable<T>> AddRangeAsync(IEnumerable<T> entities);

        Task<T> FirstOrDefaultAsync(Expression<Func<T, bool>> predicate);
    }
}
