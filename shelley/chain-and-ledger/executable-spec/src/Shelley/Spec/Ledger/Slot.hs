{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Shelley.Spec.Ledger.Slot
  ( SlotNo (..),
    Duration (..),
    (-*),
    (+*),
    (*-),
    EpochNo (..),
    EpochSize (..),
    EpochInfo,
    -- Block number
    BlockNo (..),
    epochInfoEpoch,
    epochInfoFirst,
    epochInfoSize,
  )
where

import Cardano.Prelude (NoUnexpectedThunks (..))
import Cardano.Slotting.Block (BlockNo (..))
import Cardano.Slotting.EpochInfo (EpochInfo)
import qualified Cardano.Slotting.EpochInfo as EI
import Cardano.Slotting.Slot (EpochNo (..), EpochSize (..), SlotNo (..))
import Control.Monad.Trans (lift)
import Data.Functor.Identity (Identity)
import Data.Word (Word64)
import GHC.Stack (HasCallStack)
import Shelley.Spec.Ledger.BaseTypes (ShelleyBase)

newtype Duration = Duration Word64
  deriving (Show, Eq, Ord, NoUnexpectedThunks, Num, Integral, Real, Enum)

instance Semigroup Duration where
  (Duration x) <> (Duration y) = Duration $ x + y

instance Monoid Duration where
  mempty = Duration 0
  mappend = (<>)

(-*) :: SlotNo -> SlotNo -> Duration
(SlotNo s) -* (SlotNo t) = Duration (if s > t then s - t else t - s)

(+*) :: SlotNo -> Duration -> SlotNo
(SlotNo s) +* (Duration d) = SlotNo (s + d)

-- | Subtract a duration from a slot
(*-) :: SlotNo -> Duration -> SlotNo
(SlotNo s) *- (Duration d) = SlotNo (if s > d then s - d else 0)

epochInfoEpoch ::
  HasCallStack =>
  EpochInfo Identity ->
  SlotNo ->
  ShelleyBase EpochNo
epochInfoEpoch ei = lift . EI.epochInfoEpoch ei

epochInfoFirst ::
  HasCallStack =>
  EpochInfo Identity ->
  EpochNo ->
  ShelleyBase SlotNo
epochInfoFirst ei = lift . EI.epochInfoFirst ei

epochInfoSize ::
  HasCallStack =>
  EpochInfo Identity ->
  EpochNo ->
  ShelleyBase EpochSize
epochInfoSize ei = lift . EI.epochInfoSize ei
