module Pivot.Get exposing (..)

import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)


getC : Pivot a -> a
getC (Pivot c _) =
    c


getL : Pivot a -> List a
getL (Pivot _ ( l, _ )) =
    List.reverse l


hasL : Pivot a -> Bool
hasL =
    getL >> List.length >> flip (>) 0


getR : Pivot a -> List a
getR (Pivot _ ( _, r )) =
    r


hasR : Pivot a -> Bool
hasR =
    reverse >> hasL


getA : Pivot a -> List a
getA (Pivot c ( l, r )) =
    List.reverse l ++ c :: r
