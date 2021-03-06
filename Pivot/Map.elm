module Pivot.Map exposing (..)

import Pivot.Types exposing (..)
import Pivot.Utilities exposing (..)
import Pivot.Get exposing (..)
import Pivot.Position exposing (..)


mapCLR : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCLR onC onL onR =
    mapCLR_ onC (List.map onL) (List.map onR)


mapCRL : (a -> b) -> (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCRL onC =
    flip (mapCLR onC)


mapCS : (a -> b) -> (a -> b) -> Pivot a -> Pivot b
mapCS onC onS =
    mapCLR onC onS onS


mapA : (a -> b) -> Pivot a -> Pivot b
mapA onA =
    mapCS onA onA


mapC : (a -> a) -> Pivot a -> Pivot a
mapC =
    flip mapCS identity


mapL : (a -> a) -> Pivot a -> Pivot a
mapL =
    mapCRL identity identity


mapR : (a -> a) -> Pivot a -> Pivot a
mapR f =
    mapL f
        |> mirror


mapS : (a -> a) -> Pivot a -> Pivot a
mapS =
    mapCS identity


mapCLR_ : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapCLR_ onC_ onL_ onR_ pvt =
    Pivot (pvt |> getC |> onC_) ( pvt |> getL |> onL_ |> List.reverse, pvt |> getR |> onR_ )


mapCRL_ : (a -> b) -> (List a -> List b) -> (List a -> List b) -> Pivot a -> Pivot b
mapCRL_ onC_ =
    flip (mapCLR_ onC_)


mapCS_ : (a -> b) -> (List a -> List b) -> Pivot a -> Pivot b
mapCS_ onC_ onS_ =
    mapCLR_ onC_ onS_ onS_


mapL_ : (List a -> List a) -> Pivot a -> Pivot a
mapL_ =
    mapCRL_ identity identity


mapR_ : (List a -> List a) -> Pivot a -> Pivot a
mapR_ f =
    mapL_ f
        |> mirror


mapS_ : (List a -> List a) -> Pivot a -> Pivot a
mapS_ =
    mapCS_ identity


zip : Pivot a -> Pivot ( Int, a )
zip pvt =
    let
        n =
            lengthL pvt

        onC =
            (,) n

        onL =
            List.indexedMap (,)

        onR =
            List.indexedMap ((+) (n + 1) >> (,))
    in
        mapCLR_ onC onL onR pvt


apply : Pivot (a -> b) -> Pivot a -> Pivot b
apply (Pivot cf ( lf, rf )) (Pivot c ( l, r )) =
    let
        apList fs xs =
            List.concatMap (flip List.map xs) fs
    in
        Pivot (cf c) ( apList lf l, apList rf r )
