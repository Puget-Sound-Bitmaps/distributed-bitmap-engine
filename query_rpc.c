vec_t *get_vectors(vec_id_t *)
{
    /* use the function that gets vectors from a file */
}

vec_t op(vec_t *, char *)
{
    /* execute the string of operations on the given vectors, and return
     * the result */
}

/**
 * Recursive RPC to execute range query
 */
vec_t range_query(query_args)
{
    if (query_args.recur_query_list == NULL) // no machines to visit
        return op(get_vectors(local_vectors, local_ops));
    result_vectors = [range_query()]
    
}
