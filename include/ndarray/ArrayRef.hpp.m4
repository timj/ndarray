include(`ArrayRef.macros.m4')dnl
changecom(`###')dnl
#ifndef NDARRAY_ArrayRef_hpp_INCLUDED
#define NDARRAY_ArrayRef_hpp_INCLUDED

/** 
 *  @file ndarray/ArrayRef.hpp
 *
 *  @brief Definitions for ArrayRef.
 */

#include "ndarray_fwd.hpp"
#include "ndarray/ArrayTraits.hpp"
#include "ndarray/ArrayBase.hpp"
#include "ndarray/detail/ArrayAccess.hpp"
#include "ndarray/Vector.hpp"
#include "ndarray/detail/Core.hpp"
#include "ndarray/views.hpp"

namespace ndarray {

/**
 *  @brief A proxy class for Array with deep assignment operators.
 */
template <typename T, int N, int C>
class ArrayRef : public ArrayBase< ArrayRef<T,N,C> > {
    typedef ArrayBase<ArrayRef> Super;
    typedef typename Super::Core Core;
    typedef typename Super::CorePtr CorePtr;
public:
    typedef typename Super::Iterator Iterator;

    /**
     *  @brief Non-converting copy constructor.
     */
    ArrayRef(ArrayRef const & other) : Super(other._data, other._core) {}

    /**
     *  @brief Converting copy constructor. 
     *
     *  Implicit conversion is allowed for non-const to const and for 
     *  more guaranteed RMC to less guaranteed RMC (see \ref overview).
     */
    template <typename T_, int C_>
    explicit ArrayRef(
        Array<T_,N,C_> const & other
#ifndef DOXYGEN
        , typename boost::enable_if_c<((C_>=C) && boost::is_convertible<T_*,T*>::value),void*>::type=0
#endif
    ) : Super(other._data, other._core) {}

    /**
     *  @brief Converting copy constructor. 
     *
     *  Implicit conversion is allowed for non-const to const and for 
     *  more guaranteed RMC to less guaranteed RMC (see \ref overview).
     */
    template <typename T_, int C_>
    ArrayRef(
        ArrayRef<T_,N,C_> const & other
#ifndef DOXYGEN
        , typename boost::enable_if_c<((C_>=C) && boost::is_convertible<T_*,T*>::value),void*>::type=0
#endif
    ) : Super(other._data, other._core) {}

    /**
     *  @name Assignment and Augmented Assignment Operators
     *
     *  ArrayRef assignment is deep, and requires that
     *  the ArrayRef being assigned to has the same shape as
     *  the input array expression.  Scalar assignment sets
     *  all elements of the ArrayRef to a single value.
     */
    /// @{
BASIC_ASSIGN
AUGMENTED_ASSIGN(+=)
AUGMENTED_ASSIGN(-=)
AUGMENTED_ASSIGN(*=)
AUGMENTED_ASSIGN(/=)
AUGMENTED_ASSIGN(%=)
AUGMENTED_ASSIGN(^=)
AUGMENTED_ASSIGN(&=)
AUGMENTED_ASSIGN(|=)
AUGMENTED_ASSIGN(<<=)
AUGMENTED_ASSIGN(>>=)
    ///@}

private:
    template <typename T_, int N_, int C_> friend class Array;
    template <typename T_, int N_, int C_> friend class ArrayRef;
    template <typename T_, int N_, int C_> friend struct ArrayTraits;
    template <typename Derived> friend class ArrayBase;
    template <typename Array_> friend class detail::ArrayAccess;

    /// @internal @brief Construct an ArrayRef from a pointer and Core.
    ArrayRef(T * data, CorePtr const & core) : Super(data, core) {}

};

} // namespace ndarray

#endif // !NDARRAY_ArrayRef_hpp_INCLUDED