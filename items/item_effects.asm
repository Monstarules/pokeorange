_DoItemEffect:: ; e722
	ld a, [wCurItem]
	ld [wd265], a
	call GetItemName
	call CopyName1
	ld a, 1
	ld [wItemEffectSucceeded], a
	ld a, [wCurItem]
	dec a
	ld hl, ItemEffects
	rst JumpTable
	ret
; e73c


ItemEffects: ; e73c
	dw MasterBall
	dw UltraBall
	dw Brightpowder
	dw GreatBall
	dw PokeBall
	dw TownMap
	dw Skateboard
	dw MoonStone
	dw Antidote
	dw BurnHeal
	dw IceHeal
	dw Awakening
	dw ParlyzHeal
	dw FullRestore
	dw MaxPotion
	dw HyperPotion
	dw SuperPotion
	dw Potion
	dw EscapeRope
	dw Repel
	dw MaxElixer
	dw FireStone
	dw Thunderstone
	dw WaterStone
	dw PinkanBerry
	dw HPUp
	dw Protein
	dw Iron
	dw Carbos
	dw LuckyPunch
	dw Calcium
	dw RareCandy
	dw XAccuracy
	dw LeafStone
	dw MetalPowder
	dw Nugget
	dw PokeDoll
	dw FullHeal
	dw Revive
	dw MaxRevive
	dw GuardSpec
	dw SuperRepel
	dw MaxRepel
	dw DireHit
	dw MasterRod
	dw FreshWater
	dw SodaPop
	dw Lemonade
	dw XAttack
	dw XDefend
	dw XSpeed
	dw XSpclAtk
	dw CoinCase
	dw Itemfinder
	dw PokeFlute
	dw ExpAll
	dw OldRod
	dw GoodRod
	dw SuperRod
	dw PPUp
	dw PPMax
	dw Ether
	dw MaxEther
	dw Elixer
	dw PinkCure
	dw HeartScale
	dw QuickClaw
	dw Psncureberry
	dw SoftSand
	dw SharpBeak
	dw Przcureberry
	dw BurntBerry
	dw IceBerry
	dw PoisonBarb
	dw KingsRock
	dw BitterBerry
	dw MintBerry
	dw Tinymushroom
	dw BigMushroom
	dw Silverpowder
	dw AmuletCoin
	dw CleanseTag
	dw MysticWater
	dw Twistedspoon
	dw Blackbelt
	dw Blackglasses
	dw PinkBow
	dw Stick
	dw SmokeBall
	dw Nevermeltice
	dw Magnet
	dw Miracleberry
	dw Pearl
	dw BigPearl
	dw Everstone
	dw SpellTag
	dw SweetOrange
	dw GSBall
	dw MiracleSeed
	dw ThickClub
	dw FocusBand
	dw Energypowder
	dw EnergyRoot
	dw HealPowder
	dw RevivalHerb
	dw HardStone
	dw LuckyEgg
	dw Stardust
	dw StarPiece
	dw Charcoal
	dw BerryJuice
	dw ScopeLens
	dw MetalCoat
	dw DragonFang
	dw Leftovers
	dw Mysteryberry
	dw DragonScale
	dw HeavyBall
	dw LevelBall
	dw LureBall
	dw FastBall
	dw LightBall
	dw FriendBall
	dw MoonBall
	dw LoveBall
	dw SunStone
	dw PolkadotBow
	dw UpGrade
	dw Berry
	dw GoldBerry
	dw Squirtbottle
	dw ParkBall
	dw BerserkGene
	dw SacredAsh
	dw SilverWing
	dw RainbowWing
	dw ShinyStone
	dw TradeStone
	dw MoroTrophy
	dw DubiousDisc
	dw ShinyCharm
	dw SoulDew
	dw DiveBall
	dw HealBall
	dw DuskBall
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw FlowerMail
	dw XSpclDef
	dw IceStone
	dw QuickPowder
	dw Magmarizer
	dw Electirizer
	dw Protector
	dw SalveyoWeed
	dw CatStatue
	dw ShellBox
; e8a2


MasterBall:
UltraBall:
GreatBall:
PokeBall:
HeavyBall:
LevelBall:
LureBall:
FastBall:
FriendBall:
MoonBall:
LoveBall:
ParkBall:
DiveBall:
HealBall:
DuskBall: ; e8a2
	ld a, [wBattleMode]
	dec a
	jp nz, UseBallInTrainerBattle

	ld a, [PartyCount]
	cp PARTY_LENGTH
	jr nz, .room_in_party

	ld a, BANK(sBoxCount)
	call GetSRAMBank
	ld a, [sBoxCount]
	cp MONS_PER_BOX
	call CloseSRAM
	jp z, Ball_BoxIsFullMessage

.room_in_party
	xor a
	ld [wWildMon], a
	ld a, [wCurItem]
	cp PARK_BALL
	call nz, ReturnToBattle_UseBall

	ld hl, wOptions
	res NO_TEXT_SCROLL, [hl]
	ld hl, UsedItemText
	call PrintText

	ld a, [EnemyMonCatchRate]
	ld b, a
	ld a, [wCurItem]
	cp MASTER_BALL
	jp z, .catch_without_fail
	ld a, [wCurItem]
	ld c, a
	ld hl, BallMultiplierFunctionTable

.get_multiplier_loop
	ld a, [hli]
	cp $ff
	jr z, .skip_ball_fn
	cp c
	jr z, .call_ball_function
	inc hl
	inc hl
	jr .get_multiplier_loop

.call_ball_function
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call _hl_

.skip_ball_fn
	ld a, [wCurItem]
	cp LEVEL_BALL
	ld a, b
	jp z, .skip_hp_calc

	ld a, b
	ld [hMultiplicand + 2], a

	ld hl, EnemyMonHP
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld e, [hl]
	sla c
	rl b

	ld h, d
	ld l, e
	add hl, de
	add hl, de
	ld d, h
	ld e, l
	ld a, d
	and a
	jr z, .okay_1

	srl d
	rr e
	srl d
	rr e
	srl b
	rr c
	srl b
	rr c

	ld a, c
	and a
	jr nz, .okay_1
	ld c, $1
.okay_1
	ld b, e

	push bc
	ld a, b
	sub c
	ld [hMultiplier], a
	xor a
	ld [hDividend + 0], a
	ld [hMultiplicand + 0], a
	ld [hMultiplicand + 1], a
	call Multiply
	pop bc

	ld a, b
	ld [hDivisor], a
	ld b, $4
	call Divide

	ld a, [hQuotient + 2]
	and a
	jr nz, .statuscheck
	ld a, 1
.statuscheck
	ld b, a
	ld a, [EnemyMonStatus]
	and 1 << FRZ | SLP
	ld c, 10
	jr nz, .addstatus
	ld a, [EnemyMonStatus]
	and a
	ld c, 5
	jr nz, .addstatus
	ld c, 0
.addstatus
	ld a, b
	add c
	jr nc, .max_1
	ld a, $ff
.max_1

	ld d, a
	push de

	ld a, [BattleMonItem]
	ld b, a
	farcall GetItemHeldEffect
	ld a, b
	cp HELD_CATCH_CHANCE

	pop de
	ld a, d

	jr nz, .skip_hp_calc
	add c
	jr nc, .skip_hp_calc
	ld a, $ff
.skip_hp_calc

	ld b, a
	ld [Buffer1], a
	call Random

	cp b
	ld a, 0
	jr z, .catch_without_fail
	jr nc, .fail_to_catch

.catch_without_fail
	ld a, [EnemyMonSpecies]

.fail_to_catch
	ld [wWildMon], a
	ld c, 20
	call DelayFrames

	ld a, [wCurItem]
	cp POKE_BALL + 1 ; Assumes Master/Ultra/Great come before
	jr c, .not_kurt_ball
	ld a, POKE_BALL
.not_kurt_ball
	ld [wBattleAnimParam], a

	ld de, ANIM_THROW_POKE_BALL
	ld a, e
	ld [FXAnimIDLo], a
	ld a, d
	ld [FXAnimIDHi], a
	xor a
	ld [hBattleTurn], a
	ld [Buffer2], a
	ld [wNumHits], a
	predef PlayBattleAnim

	ld a, [wWildMon]
	and a
	jr nz, .caught
	ld a, [Buffer2]
	cp $1
	ld hl, Text_NoShake
	jp z, .shake_and_break_free
	cp $2
	ld hl, Text_OneShake
	jp z, .shake_and_break_free
	cp $3
	ld hl, Text_TwoShakes
	jp z, .shake_and_break_free
	cp $4
	ld hl, Text_ThreeShakes
	jp z, .shake_and_break_free
.caught

	ld hl, EnemyMonStatus
	ld a, [hli]
	push af
	inc hl
	ld a, [hli]
	push af
	ld a, [hl]
	push af
	push hl
	ld hl, EnemyMonItem
	ld a, [hl]
	push af
	push hl
	ld hl, EnemySubStatus5
	ld a, [hl]
	push af
	set SUBSTATUS_TRANSFORMED, [hl]
	bit SUBSTATUS_TRANSFORMED, a
	jr z, .not_ditto

	ld a, DITTO
	ld [TempEnemyMonSpecies], a
	jr .load_data

.not_ditto
	set SUBSTATUS_TRANSFORMED, [hl]
	ld hl, wEnemyBackupDVs
	ld a, [EnemyMonDVs]
	ld [hli], a
	ld a, [EnemyMonDVs + 1]
	ld [hl], a
	ld hl, wEnemyBackupPersonality
	ld a, [EnemyMonPersonality]
	ld [hl], a

.load_data
	ld a, [TempEnemyMonSpecies]
	ld [CurPartySpecies], a
	ld [EnemyMonSpecies], a
	ld a, [EnemyMonLevel]
	ld [CurPartyLevel], a
    ld hl, wEnemyBackupDVs
        ld de, EnemyMonDVs
        ld bc, 2
        call CopyBytes

        ld hl, wWildMonMoves
        ld de, EnemyMonMoves
        ld bc, NUM_MOVES
        call CopyBytes

        ld hl, wWildMonPP
        ld de, EnemyMonPP
        ld bc, NUM_MOVES
        call CopyBytes

	pop af
	ld [EnemySubStatus5], a

	pop hl
	pop af
	ld [hl], a
	pop hl
	pop af
	ld [hld], a
	pop af
	ld [hld], a
	dec hl
	pop af
	ld [hl], a

	ld hl, EnemySubStatus5
	bit SUBSTATUS_TRANSFORMED, [hl]
	jr nz, .Transformed
	ld hl, wWildMonMoves
	ld de, EnemyMonMoves
	ld bc, NUM_MOVES
	call CopyBytes

	ld hl, wWildMonPP
	ld de, EnemyMonPP
	ld bc, NUM_MOVES
	call CopyBytes

.Transformed:
	ld a, [EnemyMonSpecies]
	push af
	ld [wWildMon], a
	ld [CurPartySpecies], a
	ld [wd265], a

	ld hl, Text_GotchaMonWasCaught
	call PrintText

	call ClearSprites

	farcall GiveExperiencePoints
	ld a, [EnemyMonLevel]
	ld [CurPartyLevel], a

	pop af
	ld [wWildMon], a
	ld [CurPartySpecies], a
	ld [wd265], a
	dec a
	call CheckCaughtMon

	ld a, c
	push af
	ld a, [wd265]
	dec a
	call SetSeenAndCaughtMon
	pop af
	and a
	jr nz, .skip_pokedex

	call CheckReceivedDex
	jr z, .skip_pokedex

	ld hl, Text_AddedToPokedex
	call PrintText

	call ClearSprites

	ld a, [EnemyMonSpecies]
	ld [wd265], a
	predef NewPokedexEntry

.skip_pokedex
	ld a, [BattleType]
	cp BATTLETYPE_CONTEST
	jp z, .catch_bug_contest_mon

	ld a, [PartyCount]
	cp PARTY_LENGTH
	jp z, .SendToPC

	xor a ; PARTYMON
	ld [MonType], a
	call ClearSprites

	predef TryAddMonToParty

	farcall SetCaughtData

	ld a, [wCurItem]
	cp FRIEND_BALL
	jr nz, .SkipPartyMonFriendBall

	ld a, [PartyCount]
	dec a
	ld hl, PartyMon1Happiness
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes

	ld a, FRIEND_BALL_HAPPINESS
	ld [hl], a
.SkipPartyMonFriendBall:

	ld a, [wCurItem]
	cp HEAL_BALL
	jr nz, .SkipPartyMonHealBall

	ld a, [PartyCount]
	dec a
	ld [wCurPartyMon], a
	farcall HealPartyMon
.SkipPartyMonHealBall:

	ld hl, Text_AskNicknameNewlyCaughtMon
	call PrintText

	ld a, [CurPartySpecies]
	ld [wd265], a
	call GetPokemonName

	call YesNoBox
	jp c, .return_from_capture

	ld a, [PartyCount]
	dec a
	ld [wCurPartyMon], a
	ld hl, PartyMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call AddNTimes

	ld d, h
	ld e, l
	push de
	xor a ; PARTYMON
	ld [MonType], a
	ld b, $0 ; mon
	farcall NamingScreen

	call RotateThreePalettesRight

	call LoadStandardFont

	pop hl
	ld de, StringBuffer1
	call InitName

	jp .return_from_capture

.SendToPC:
	call ClearSprites

	predef SentPkmnIntoBox

	farcall SetBoxMonCaughtData

	ld a, BANK(sBoxCount)
	call GetSRAMBank

	ld a, [sBoxCount]
	cp MONS_PER_BOX
	jr nz, .BoxNotFullYet
	ld hl, wBattleResult
	set 7, [hl]
.BoxNotFullYet:
	ld a, [wCurItem]
	cp FRIEND_BALL
	jr nz, .SkipBoxMonFriendBall
	; Bug: overwrites the happiness of the first mon in the box!
	ld a, FRIEND_BALL_HAPPINESS
	ld [sBoxMon1Happiness], a
.SkipBoxMonFriendBall:
	call CloseSRAM

	ld hl, Text_AskNicknameNewlyCaughtMon
	call PrintText

	ld a, [CurPartySpecies]
	ld [wd265], a
	call GetPokemonName

	call YesNoBox
	jr c, .SkipBoxMonNickname

	xor a
	ld [wCurPartyMon], a
	ld a, BOXMON
	ld [MonType], a
	ld de, wMonOrItemNameBuffer
	ld b, $0 ; mon
	farcall NamingScreen

	ld a, BANK(sBoxMonNicknames)
	call GetSRAMBank

	ld hl, wMonOrItemNameBuffer
	ld de, sBoxMonNicknames
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes

	ld hl, sBoxMonNicknames
	ld de, StringBuffer1
	call InitName

	call CloseSRAM

.SkipBoxMonNickname:
	ld a, BANK(sBoxMonNicknames)
	call GetSRAMBank

	ld hl, sBoxMonNicknames
	ld de, wMonOrItemNameBuffer
	ld bc, PKMN_NAME_LENGTH
	call CopyBytes

	call CloseSRAM

	ld hl, Text_SentToBillsPC
	call PrintText

	call RotateThreePalettesRight
	call LoadStandardFont
	jr .return_from_capture

.catch_bug_contest_mon
	farcall BugContest_SetCaughtContestMon
	jr .return_from_capture

.shake_and_break_free
	call PrintText
	call ClearSprites

.return_from_capture
	ld a, [BattleType]
	cp BATTLETYPE_CONTEST
	jr z, .used_park_ball

	ld a, [wWildMon]
	and a
	jr z, .toss

	call ClearBGPalettes
	call ClearTileMap

.toss
	ld hl, NumItems
	inc a
	ld [wItemQuantityChangeBuffer], a
	jp TossItem

.used_park_ball
	ld hl, wParkBallsRemaining
	dec [hl]
	ret
; ec0a


BallMultiplierFunctionTable:
; table of routines that increase or decrease the catch rate based on
; which ball is used in a certain situation.
	dbw ULTRA_BALL,  UltraBallMultiplier
	dbw GREAT_BALL,  GreatBallMultiplier
	dbw HEAVY_BALL,  HeavyBallMultiplier
	dbw LEVEL_BALL,  LevelBallMultiplier
	dbw LURE_BALL,   LureBallMultiplier
	dbw FAST_BALL,   FastBallMultiplier
	dbw MOON_BALL,   MoonBallMultiplier
	dbw LOVE_BALL,   LoveBallMultiplier
	dbw PARK_BALL,   ParkBallMultiplier
	dbw PARK_BALL,   ParkBallMultiplier
	dbw DIVE_BALL,   DiveBallMultiplier
	dbw DUSK_BALL,   DuskBallMultiplier
	db $ff

UltraBallMultiplier:
; multiply catch rate by 2
	sla b
	ret nc
	ld b, $ff
	ret

GreatBallMultiplier:
ParkBallMultiplier:
; multiply catch rate by 1.5
	ld a, b
	srl a
	add b
	ld b, a
	ret nc
	ld b, $ff
	ret

GetPokedexEntryBank:
	push hl
	push de
	ld a, [EnemyMonSpecies]
	rlca
	rlca
	and 3
	ld hl, .PokedexEntryBanks
	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	pop de
	pop hl
	ret

.PokedexEntryBanks:

EXPORT PokedexEntries1
EXPORT PokedexEntries2
EXPORT PokedexEntries3
EXPORT PokedexEntries4

	db BANK(PokedexEntries1)
	db BANK(PokedexEntries2)
	db BANK(PokedexEntries3)
	db BANK(PokedexEntries4)

HeavyBallMultiplier:
; subtract 20 from catch rate if weight < 102.4 kg
; else add 0 to catch rate if weight < 204.8 kg
; else add 20 to catch rate if weight < 307.2 kg
; else add 30 to catch rate if weight < 409.6 kg
; else add 40 to catch rate (never happens)
	ld a, [EnemyMonSpecies]
	ld hl, PokedexDataPointerTable
	dec a
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, BANK(PokedexDataPointerTable)
	call GetFarHalfword

.SkipText:
	call GetPokedexEntryBank
	call GetFarByte
	inc hl
	cp "@"
	jr nz, .SkipText

	call GetPokedexEntryBank
	push bc
	inc hl
	inc hl
	call GetFarHalfword

	srl h
	rr l
	ld b, h
	ld c, l

	rept 4
	srl b
	rr c
	endr
	call .subbc

	srl b
	rr c
	call .subbc

	ld a, h
	pop bc
	jr .compare

.subbc
	; subtract bc from hl
	push bc
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	add hl, bc
	pop bc
	ret

.compare
	ld c, a
	cp 1024 >> 8 ; 102.4 kg
	jr c, .lightmon

	ld hl, .WeightsTable
.lookup
	ld a, c
	cp [hl]
	jr c, .heavymon
	inc hl
	inc hl
	jr .lookup

.heavymon
	inc hl
	ld a, b
	add [hl]
	ld b, a
	ret nc
	ld b, $ff
	ret

.lightmon
	ld a, b
	sub 20
	ld b, a
	ret nc
	ld b, $1
	ret

.WeightsTable:
; weight factor, boost
	db 2048 >> 8, 0
	db 3072 >> 8, 20
	db 4096 >> 8, 30
	db 65280 >> 8, 40

LureBallMultiplier:
; multiply catch rate by 3 if this is a fishing rod battle
	ld a, [BattleType]
	cp BATTLETYPE_FISH
	ret nz

	ld a, b
	add a
	jr c, .max

	add b
	jr nc, .done
.max
	ld a, $ff
.done
	ld b, a
	ret

MoonBallMultiplier:
; multiply catch rate by 4 if mon evolves with moon stone

EXPORT EvosAttacks
EXPORT EvosAttacksPointers

	push bc
	ld a, [TempEnemyMonSpecies]
	dec a
	ld c, a
	ld b, 0
	ld hl, EvosAttacksPointers
	add hl, bc
	add hl, bc
	ld a, BANK(EvosAttacksPointers)
	call GetFarHalfword
	pop bc

	push bc
	ld a, BANK(EvosAttacks)
	call GetFarByte
	cp EVOLVE_ITEM
	pop bc
	ret nz

	inc hl
	inc hl
	inc hl

	push bc
	ld a, BANK(EvosAttacks)
	call GetFarByte
	cp MOON_STONE
	pop bc
	ret nz

	sla b
	jr c, .max
	sla b
	ret nc
.max
	ld b, $ff
	ret

LoveBallMultiplier:
; multiply catch rate by 8 if mons are of same species, different sex

	; does species match?
	ld a, [TempEnemyMonSpecies]
	ld c, a
	ld a, [TempBattleMonSpecies]
	cp c
	ret nz

	; check player mon species
	push bc
	ld a, [TempBattleMonSpecies]
	ld [CurPartySpecies], a
	xor a ; PARTYMON
	ld [MonType], a
	ld a, [CurBattleMon]
	ld [wCurPartyMon], a
	farcall GetGender
	jr c, .done1 ; no effect on genderless

	ld d, 0 ; male
	jr nz, .playermale
	inc d   ; female
.playermale

	; check wild mon species
	push de
	ld a, [TempEnemyMonSpecies]
	ld [CurPartySpecies], a
	ld a, WILDMON
	ld [MonType], a
	farcall GetGender
	jr c, .done2 ; no effect on genderless

	ld d, 0 ; male
	jr nz, .wildmale
	inc d   ; female
.wildmale

	ld a, d
	pop de
	cp d
	pop bc
	ret z

	sla b
	jr c, .max
	sla b
	jr c, .max
	sla b
	ret nc
.max
	ld b, $ff
	ret

.done2
	pop de

.done1
	pop bc
	ret

FastBallMultiplier:
; multiply catch rate by 4 if enemy mon is in one of the three FleeMons tables
	ld a, [TempEnemyMonSpecies]
	ld c, a
	ld hl, FleeMons
	ld d, 3

.loop
	ld a, BANK(FleeMons)
	call GetFarByte

	inc hl
	cp -1
	jr z, .next
	cp c
	jr nz, .loop
	sla b
	jr c, .max

	sla b
	ret nc

.max
	ld b, $ff
	ret

.next
	dec d
	jr nz, .loop
	ret

LevelBallMultiplier:
; multiply catch rate by 8 if player mon level / 4 > enemy mon level
; multiply catch rate by 4 if player mon level / 2 > enemy mon level
; multiply catch rate by 2 if player mon level > enemy mon level
	ld a, [BattleMonLevel]
	ld c, a
	ld a, [EnemyMonLevel]
	cp c
	ret nc ; if player is lower level, we're done here
	sla b
	jr c, .max

	srl c
	cp c
	ret nc ; if player/2 is lower level, we're done here
	sla b
	jr c, .max

	srl c
	cp c
	ret nc ; if player/4 is lower level, we're done here
	sla b
	ret nc

.max
	ld b, $ff
	ret

DiveBallMultiplier:
; multiply catch rate by 3.5 if underwater
	ld a, [wTileset]
	cp TILESET_UNDERWATER
	ret nz
	ld a, b
	srl a
	add b
	add b
	add b
	ld b, a
	ret nc
	ld b, $ff
	ret

DuskBallMultiplier:
; multiply catch rate by 3.5 at night or in caves
	ld a, [wPermission]
	cp CAVE
	jr z, .dusk

	ld a, [TimeOfDay]
	cp 1 << NITE
	jr z, .dusk

	ret

.dusk
	ld a, b
	srl a
	add b
	add b
	add b
	ld b, a
	ret nc
	ld b, $ff
	ret

Text_NoShake: ; 0xedb5
	; Oh no! The #MON broke free!
	text_jump UnknownText_0x1c5aa6
	db "@"
; 0xedba

Text_OneShake: ; 0xedba
	; Aww! It appeared to be caught!
	text_jump UnknownText_0x1c5ac3
	db "@"
; 0xedbf

Text_TwoShakes: ; 0xedbf
	; Aargh! Almost had it!
	text_jump UnknownText_0x1c5ae3
	db "@"
; 0xedc4

Text_ThreeShakes: ; 0xedc4
	; Shoot! It was so close too!
	text_jump UnknownText_0x1c5afa
	db "@"
; 0xedc9

Text_GotchaMonWasCaught: ; 0xedc9
	; Gotcha! @ was caught!@ @
	text_jump UnknownText_0x1c5b17
	start_asm
	call WaitSFX
	push bc
	ld de, MUSIC_NONE
	call PlayMusic
	call DelayFrame
	ld de, MUSIC_CAPTURE
	call PlayMusic
	pop bc
	ld hl, TextJump_Waitbutton
	ret
; ede6

TextJump_Waitbutton: ; 0xede6
	; @
	text_jump Text_Waitbutton_2
	db "@"
; 0xedeb

Text_SentToBillsPC: ; 0xedeb
	; was sent to BILL's PC.
	text_jump UnknownText_0x1c5b38
	db "@"
; 0xedf0

Text_AddedToPokedex: ; 0xedf0
	; 's data was newly added to the #DEX.@ @
	text_jump UnknownText_0x1c5b53
	db "@"
; 0xedf5

Text_AskNicknameNewlyCaughtMon: ; 0xedf5
	; Give a nickname to @ ?
	text_jump UnknownText_0x1c5b7f
	db "@"
; 0xedfa

ReturnToBattle_UseBall: ; edfa (3:6dfa)
	farcall _ReturnToBattle_UseBall
	ret

TownMap: ; ee01
;	farcall Special_TownMapItem
	call FadeToMenu
	farcall _TownMap
	call Call_ExitMenu
	xor a
	ldh [hBGMapMode], a
	farcall Pack_InitGFX
	farcall WaitBGMap_DrawPackGFX
	farcall Pack_InitColors
	ret
; ee08


Skateboard: ; ee08
	farcall BikeFunction
	ret
; ee0f


MoonStone:
FireStone:
Thunderstone:
WaterStone:
LeafStone:
SunStone:
ShinyStone:
TradeStone:
UpGrade:
DubiousDisc:
IceStone:
Magmarizer:
Electirizer:
Protector: ; ee0f
	ld b, PARTYMENUACTION_EVO_STONE
	call UseItem_SelectMon

	jp c, .DecidedNotToUse

	ld a, MON_ITEM
	call GetPartyParamLocation

	ld a, [hl]
	cp EVERSTONE
	jr z, .NoEffect

	ld a, $1
	ld [wForceEvolution], a
	farcall EvolvePokemon

	ld a, [wMonTriedToEvolve]
	and a
	jp nz, UseDisposableItem

.NoEffect:
	call WontHaveAnyEffectMessage

.DecidedNotToUse:
	xor a
	ld [wItemEffectSucceeded], a
	ret
; ee3d


HPUp:
Protein:
Iron:
Carbos:
Calcium: ; ee3d
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon

	jp c, RareCandy_StatBooster_ExitMenu

	call RareCandy_StatBooster_GetParameters

	call GetStatExpRelativePointer

	ld a, MON_STAT_EXP
	call GetPartyParamLocation

	add hl, bc
	ld a, [hl]
	cp 100
	jr nc, NoEffectMessage

	add 10
	ld [hl], a
	call UpdateStatsAfterItem

	call GetStatExpRelativePointer

	ld hl, StatStrings
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, StringBuffer2
	ld bc, ITEM_NAME_LENGTH
	call CopyBytes

	call Play_SFX_FULL_HEAL

	ld hl, Text_StatRose
	call PrintText

	ld c, HAPPINESS_USEDITEM
	farcall ChangeHappiness

	jp UseDisposableItem


NoEffectMessage: ; ee83
	ld hl, WontHaveAnyEffectText
	call PrintText
	jp ClearPalettes
; ee8c


UpdateStatsAfterItem: ; ee8c
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld d, h
	ld e, l
	ld a, MON_STAT_EXP - 1
	call GetPartyParamLocation
	ld b, $1
	predef_jump CalcPkmnStats
; ee9f

RareCandy_StatBooster_ExitMenu: ; ee9f
	xor a
	ld [wItemEffectSucceeded], a
	jp ClearPalettes
; eea6


Text_StatRose: ; 0xeea6
	; 's @  rose.
	text_jump UnknownText_0x1c5b9a
	db "@"
; 0xeeab


StatStrings: ; eeab
	dw .health
	dw .attack
	dw .defense
	dw .speed
	dw .special

.health  db "HEALTH@"
.attack  db "ATTACK@"
.defense db "DEFENSE@"
.speed   db "SPEED@"
.special db "SPECIAL@"
; eed9


GetStatExpRelativePointer: ; eed9
	ld a, [wCurItem]
	ld hl, Table_eeeb
.next
	cp [hl]
	inc hl
	jr z, .got_it
	inc hl
	jr .next

.got_it
	ld a, [hl]
	ld c, a
	ld b, 0
	ret
; eeeb

Table_eeeb: ; eeeb
	db HP_UP,    MON_HP_EXP - MON_STAT_EXP
	db PROTEIN, MON_ATK_EXP - MON_STAT_EXP
	db IRON,    MON_DEF_EXP - MON_STAT_EXP
	db CARBOS,  MON_SPD_EXP - MON_STAT_EXP
	db CALCIUM, MON_SPC_EXP - MON_STAT_EXP
; eef5


RareCandy_StatBooster_GetParameters: ; eef5
	ld a, [CurPartySpecies]
	ld [CurSpecies], a
	ld [wd265], a
	ld a, MON_LEVEL
	call GetPartyParamLocation
	ld a, [hl]
	ld [CurPartyLevel], a
	call GetBaseData
	ld a, [wCurPartyMon]
	ld hl, PartyMonNicknames
	jp GetNick
; 0xef14


RareCandy: ; ef14
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon

	jp c, RareCandy_StatBooster_ExitMenu

	call RareCandy_StatBooster_GetParameters

	ld a, MON_LEVEL
	call GetPartyParamLocation

	ld a, [hl]
	cp MAX_LEVEL
	jp nc, NoEffectMessage

	inc a
	ld [hl], a
	ld [CurPartyLevel], a
	push de
	ld d, a
	farcall CalcExpAtLevel

	pop de
	ld a, MON_EXP
	call GetPartyParamLocation

	ld a, [hMultiplicand]
	ld [hli], a
	ld a, [hMultiplicand + 1]
	ld [hli], a
	ld a, [hMultiplicand + 2]
	ld [hl], a

	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld a, [hli]
	ld b, a
	ld c, [hl]
	push bc
	call UpdateStatsAfterItem

	ld a, MON_MAXHP + 1
	call GetPartyParamLocation

	pop bc
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	dec hl
	ld a, [hl]
	add c
	ld [hld], a
	ld a, [hl]
	adc b
	ld [hl], a
	farcall LevelUpHappinessMod

	ld a, PARTYMENUTEXT_LEVEL_UP
	call ItemActionText

	xor a ; PARTYMON
	ld [MonType], a
	predef CopyPkmnToTempMon

	hlcoord 9, 0
	lb bc, 10, 9
	call TextBox

	hlcoord 11, 1
	ld bc, $0004
	predef PrintTempMonStats

	call WaitPressAorB_BlinkCursor

	xor a ; PARTYMON
	ld [MonType], a
	ld a, [CurPartySpecies]
	ld [wd265], a
	predef LearnLevelMoves

	xor a
	ld [wForceEvolution], a
	farcall EvolvePokemon

	jp UseDisposableItem
; efad


HealPowder: ; efad
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon

	jp c, StatusHealer_ExitMenu

	call UseStatusHealer

	and a
	jr nz, .asm_efc9
	ld c, HAPPINESS_BITTERPOWDER
	farcall ChangeHappiness

	call LooksBitterMessage

	ld a, $0

.asm_efc9
	jp StatusHealer_Jumptable
; efcc


Antidote:
BurnHeal:
IceHeal:
Awakening:
ParlyzHeal:
FullHeal:
Psncureberry:
Przcureberry:
BurntBerry:
IceBerry:
MintBerry:
Miracleberry: ; efcc
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
	jp c, StatusHealer_ExitMenu

FullyHealStatus: ; efd4
	call UseStatusHealer
	jp StatusHealer_Jumptable
; efda


UseStatusHealer: ; efda (3:6fda)
	call IsMonFainted
	ld a, $1
	ret z
	call GetItemHealingAction
	ld a, MON_STATUS
	call GetPartyParamLocation
	ld a, [hl]
	and c
	jr nz, .good
	call IsItemUsedOnConfusedMon
	ld a, $1
	ret nc
	ld b, PARTYMENUTEXT_HEAL_CONFUSION
.good
	xor a
	ld [hl], a
	ld a, b
	ld [PartyMenuActionText], a
	call HealStatus
	call Play_SFX_FULL_HEAL
	call ItemActionTextWaitButton
	call UseDisposableItem
	ld a, $0
	ret

IsItemUsedOnConfusedMon: ; f009 (3:7009)
	call IsItemUsedOnBattleMon
	jr nc, .nope
	ld a, [PlayerSubStatus3]
	bit SUBSTATUS_CONFUSED, a
	jr z, .nope
	ld a, c
	cp $ff
	jr nz, .nope
	scf
	ret

.nope
	and a
	ret

BattlemonRestoreHealth: ; f01e (3:701e)
	call IsItemUsedOnBattleMon
	ret nc
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld [BattleMonHP], a
	ld a, [hld]
	ld [BattleMonHP + 1], a
	ret

HealStatus: ; f030 (3:7030)
	call IsItemUsedOnBattleMon
	ret nc
	xor a
	ld [BattleMonStatus], a
	ld hl, PlayerSubStatus5
	res SUBSTATUS_TOXIC, [hl]
	ld hl, PlayerSubStatus1
	res SUBSTATUS_NIGHTMARE, [hl]
	call GetItemHealingAction
	ld a, c
	cp %11111111
	jr nz, .not_full_heal
	ld hl, PlayerSubStatus3
	res SUBSTATUS_CONFUSED, [hl]
.not_full_heal
	push bc
	farcall CalcPlayerStats
	pop bc
	ret

GetItemHealingAction: ; f058 (3:7058)
	push hl
	ld a, [wCurItem]
	ld hl, .healingactions
	ld bc, 3
.next
	cp [hl]
	jr z, .found_it
	add hl, bc
	jr .next

.found_it
	inc hl
	ld b, [hl]
	inc hl
	ld a, [hl]
	ld c, a
	cp %11111111
	pop hl
	ret
; f071 (3:7071)

.healingactions ; f071
; item, party menu action text, status
	db ANTIDOTE,     PARTYMENUTEXT_HEAL_PSN, 1 << PSN
	db BURN_HEAL,    PARTYMENUTEXT_HEAL_BRN, 1 << BRN
	db ICE_HEAL,     PARTYMENUTEXT_HEAL_FRZ, 1 << FRZ
	db AWAKENING,    PARTYMENUTEXT_HEAL_SLP, SLP
	db PARLYZ_HEAL,  PARTYMENUTEXT_HEAL_PAR, 1 << PAR
	db FULL_HEAL,    PARTYMENUTEXT_HEAL_ALL, %11111111
	db FULL_RESTORE, PARTYMENUTEXT_HEAL_ALL, %11111111
	db HEAL_POWDER,  PARTYMENUTEXT_HEAL_ALL, %11111111
	db PSNCUREBERRY, PARTYMENUTEXT_HEAL_PSN, 1 << PSN
	db PRZCUREBERRY, PARTYMENUTEXT_HEAL_PAR, 1 << PAR
	db BURNT_BERRY,  PARTYMENUTEXT_HEAL_FRZ, 1 << FRZ
	db ICE_BERRY,    PARTYMENUTEXT_HEAL_BRN, 1 << BRN
	db MINT_BERRY,   PARTYMENUTEXT_HEAL_SLP, SLP
	db MIRACLEBERRY, PARTYMENUTEXT_HEAL_ALL, %11111111
	db -1, 0, 0
; f09e

StatusHealer_Jumptable: ; f09e (3:709e)
	ld hl, .dw
	rst JumpTable
	ret

.dw ; f0a3 (3:70a3)
	dw StatusHealer_ClearPalettes
	dw StatusHealer_NoEffect
	dw StatusHealer_ExitMenu


RevivalHerb: ; f0a9
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
	jp c, StatusHealer_ExitMenu

	call RevivePokemon
	and a
	jr nz, .asm_f0c5

	ld c, HAPPINESS_REVIVALHERB
	farcall ChangeHappiness
	call LooksBitterMessage
	ld a, 0

.asm_f0c5
	jp StatusHealer_Jumptable
; f0c8


Revive:
MaxRevive: ; f0c8
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
	jp c, StatusHealer_ExitMenu

	call RevivePokemon
	jp StatusHealer_Jumptable
; f0d6


RevivePokemon: ; f0d6
	call IsMonFainted
	ld a, 1
	ret nz
	ld a, [wBattleMode]
	and a
	jr z, .skip_to_revive

	ld a, [wCurPartyMon]
	ld c, a
	ld d, 0
	ld hl, wBattleParticipantsIncludingFainted
	ld b, CHECK_FLAG
	predef FlagPredef
	ld a, c
	and a
	jr z, .skip_to_revive

	ld a, [wCurPartyMon]
	ld c, a
	ld hl, wBattleParticipantsNotFainted
	ld b, SET_FLAG
	predef FlagPredef

.skip_to_revive
	xor a
	ld [Danger], a
	ld a, [wCurItem]
	cp REVIVE
	jr z, .revive_half_hp

	call ReviveFullHP
	jr .finish_revive

.revive_half_hp
	call ReviveHalfHP

.finish_revive
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_REVIVE
	ld [PartyMenuActionText], a
	call ItemActionTextWaitButton
	call UseDisposableItem
	ld a, 0
	ret
; f128


FullRestore: ; f128
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
	jp c, StatusHealer_ExitMenu

	call IsMonFainted
	jp z, StatusHealer_NoEffect

	call IsMonAtFullHealth
	jp nc, FullyHealStatus

	xor a
	ld [Danger], a
	call ReviveFullHP
	ld a, MON_STATUS
	call GetPartyParamLocation
	xor a
	ld [hli], a
	ld [hl], a
	call HealStatus
	call BattlemonRestoreHealth
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_HEAL_HP
	ld [PartyMenuActionText], a
	call ItemActionTextWaitButton
	call UseDisposableItem
	ld a, 0
	jp StatusHealer_Jumptable
; f144


BitterBerry: ; f16a
	ld hl, PlayerSubStatus3
	bit SUBSTATUS_CONFUSED, [hl]
	ld a, 1
	jr z, .done

	res SUBSTATUS_CONFUSED, [hl]
	xor a
	ld [hBattleTurn], a
	call UseItemText

	ld hl, ConfusedNoMoreText
	call StdBattleTextBox

	ld a, 0

.done
	jp StatusHealer_Jumptable
; f186


MaxPotion:
HyperPotion:
SuperPotion:
Potion:
FreshWater:
SodaPop:
Lemonade:
SweetOrange:
BerryJuice:
Berry:
GoldBerry: ; f186
	call ItemRestoreHP
	jp StatusHealer_Jumptable
; f18c


Energypowder: ; f18c
	ld c, HAPPINESS_BITTERPOWDER
	jr EnergypowderEnergyRootCommon
; f190

EnergyRoot: ; f190
	ld c, HAPPINESS_ENERGYROOT
; f192

EnergypowderEnergyRootCommon: ; f192
	push bc
	call ItemRestoreHP
	pop bc
	and a
	jr nz, .skip_happiness

	farcall ChangeHappiness
	call LooksBitterMessage
	ld a, 0

.skip_happiness
	jp StatusHealer_Jumptable
; f1a9


ItemRestoreHP: ; f1a9 (3:71a9)
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
	ld a, 2
	ret c

	call IsMonFainted
	ld a, 1
	ret z

	call IsMonAtFullHealth
	ld a, 1
	ret nc

	xor a
	ld [Danger], a
	call GetHealingItemAmount
	call RestoreHealth
	call BattlemonRestoreHealth
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_HEAL_HP
	ld [PartyMenuActionText], a
	call ItemActionTextWaitButton
	call UseDisposableItem
	ld a, 0
	ret

HealHP_SFX_GFX: ; f1db (3:71db)
	push de
	ld de, SFX_POTION
	call WaitPlaySFX
	pop de
	ld a, [wCurPartyMon]
	hlcoord 11, 0
	ld bc, SCREEN_WIDTH * 2
	call AddNTimes
	ld a, $2
	ld [wWhichHPBar], a
	predef_jump AnimateHPBar

UseItem_SelectMon: ; f1f9 (3:71f9)
	call .SelectMon
	ret c

	ld a, [CurPartySpecies]
	cp EGG
	jr nz, .not_egg

	call CantUseOnEggMessage
	scf
	ret

.not_egg
	and a
	ret

.SelectMon: ; f20b (3:720b)
	ld a, b
	ld [PartyMenuActionText], a
	push hl
	push de
	push bc
	call ClearBGPalettes
	call ChoosePkmnToUseItemOn
	pop bc
	pop de
	pop hl
	ret

ChoosePkmnToUseItemOn: ; f21c (3:721c)
	farcall LoadPartyMenuGFX
	farcall InitPartyMenuWithCancel
	farcall InitPartyMenuGFX
	farcall WritePartyMenuTilemap
	farcall PrintPartyMenuText
	call WaitBGMap
	call SetPalettes
	call DelayFrame
	farcall PartyMenuSelect
	ret

ItemActionText: ; f24a (3:724a)
	ld [PartyMenuActionText], a
	ld a, [CurPartySpecies]
	push af
	ld a, [wCurPartyMon]
	push af
	push hl
	push de
	push bc
	farcall WritePartyMenuTilemap
	farcall PrintPartyMenuActionText
	call WaitBGMap
	call SetPalettes
	call DelayFrame
	pop bc
	pop de
	pop hl
	pop af
	ld [wCurPartyMon], a
	pop af
	ld [CurPartySpecies], a
	ret

ItemActionTextWaitButton: ; f279 (3:7279)
	xor a
	ld [hBGMapMode], a
	hlcoord 0, 0
	ld bc, TileMapEnd - TileMap
	ld a, " "
	call ByteFill
	ld a, [PartyMenuActionText]
	call ItemActionText
	ld a, $1
	ld [hBGMapMode], a
	ld c, 5
	call DelayFrames
	jp WaitPressAorB_BlinkCursor

StatusHealer_NoEffect: ; f299 (3:7299)
	call WontHaveAnyEffectMessage
	jr StatusHealer_ClearPalettes

StatusHealer_ExitMenu: ; f29e (3:729e)
	xor a
	ld [wItemEffectSucceeded], a
StatusHealer_ClearPalettes: ; f2a2 (3:72a2)
	jp ClearPalettes

IsItemUsedOnBattleMon: ; f2a6 (3:72a6)
	ld a, [wBattleMode]
	and a
	ret z
	ld a, [wCurPartyMon]
	push hl
	ld hl, CurBattleMon
	cp [hl]
	pop hl
	jr nz, .nope
	scf
	ret

.nope
	xor a
	ret

ReviveHalfHP: ; f2ba (3:72ba)
	call LoadHPFromBuffer1
	srl d
	rr e
	jr ContinueRevive

ReviveFullHP: ; f2c3 (3:72c3)
	call LoadHPFromBuffer1
ContinueRevive: ; f2c6 (3:72c6)
	ld a, MON_HP
	call GetPartyParamLocation
	ld [hl], d
	inc hl
	ld [hl], e
	jp LoadCurHPIntoBuffer5

RestoreHealth: ; f2d1 (3:72d1)
	ld a, MON_HP + 1
	call GetPartyParamLocation
	ld a, [hl]
	add e
	ld [hld], a
	ld a, [hl]
	adc d
	ld [hl], a
	jr c, .full_hp
	call LoadCurHPIntoBuffer5
	ld a, MON_HP + 1
	call GetPartyParamLocation
	ld d, h
	ld e, l
	ld a, MON_MAXHP + 1
	call GetPartyParamLocation
	ld a, [de]
	sub [hl]
	dec de
	dec hl
	ld a, [de]
	sbc [hl]
	ret c
.full_hp
	jp ReviveFullHP

RemoveHP: ; f2f9 (3:72f9)
	ld a, MON_HP + 1
	call GetPartyParamLocation
	ld a, [hl]
	sub e
	ld [hld], a
	ld a, [hl]
	sbc d
	ld [hl], a
	jr nc, .okay
	xor a
	ld [hld], a
	ld [hl], a
.okay
	jp LoadCurHPIntoBuffer5

IsMonFainted: ; f30d (3:730d)
	push de
	call LoadMaxHPToBuffer1
	call LoadCurHPToBuffer3
	call LoadHPFromBuffer3
	ld a, d
	or e
	pop de
	ret

IsMonAtFullHealth: ; f31b (3:731b)
	call LoadHPFromBuffer3
	ld h, d
	ld l, e
	call LoadHPFromBuffer1
	ld a, l
	sub e
	ld a, h
	sbc d
	ret

LoadCurHPIntoBuffer5: ; f328 (3:7328)
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld [Buffer6], a
	ld a, [hl]
	ld [Buffer5], a
	ret
; f336 (3:7336)

LoadCurHPToBuffer3: ; f348 (3:7348)
	ld a, MON_HP
	call GetPartyParamLocation
	ld a, [hli]
	ld [Buffer4], a
	ld a, [hl]
	ld [Buffer3], a
	ret

LoadHPFromBuffer3: ; f356 (3:7356)
	ld a, [Buffer4]
	ld d, a
	ld a, [Buffer3]
	ld e, a
	ret

LoadMaxHPToBuffer1: ; f35f (3:735f)
	push hl
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld a, [hli]
	ld [Buffer2], a
	ld a, [hl]
	ld [Buffer1], a
	pop hl
	ret

LoadHPFromBuffer1: ; f36f (3:736f)
	ld a, [Buffer2]
	ld d, a
	ld a, [Buffer1]
	ld e, a
	ret

GetOneFifthMaxHP: ; f378 (3:7378)
	push bc
	ld a, MON_MAXHP
	call GetPartyParamLocation
	ld a, [hli]
	ld [hDividend + 0], a
	ld a, [hl]
	ld [hDividend + 1], a
	ld a, 5
	ld [hDivisor], a
	ld b, 2
	call Divide
	ld a, [hQuotient + 1]
	ld d, a
	ld a, [hQuotient + 2]
	ld e, a
	pop bc
	ret

GetHealingItemAmount: ; f395 (3:7395)
	push hl
	ld a, [wCurItem]
	ld hl, .Healing
	ld d, a
.next
	ld a, [hli]
	cp -1
	jr z, .NotFound
	cp d
	jr z, .done
	inc hl
	inc hl
	jr .next

.NotFound:
	scf
.done
	ld e, [hl]
	inc hl
	ld d, [hl]
	pop hl
	ret
; f3af (3:73af)

.Healing: ; f3af
	dbw FRESH_WATER,   50
	dbw SODA_POP,      60
	dbw LEMONADE,      80
	dbw HYPER_POTION, 200
	dbw SUPER_POTION,  50
	dbw POTION,        20
	dbw MAX_POTION,   999
	dbw FULL_RESTORE, 999
	dbw BERRY,         10
	dbw GOLD_BERRY,    30
	dbw ENERGYPOWDER,  50
	dbw ENERGY_ROOT,  200
	dbw SWEET_ORANGE,  20
	dbw BERRY_JUICE,   20
	dbw -1,             0
; f3df

Softboiled_MilkDrinkFunction: ; f3df (3:73df)
; Softboiled/Milk Drink in the field
	ld a, [wPartyMenuCursor]
	dec a
	ld b, a
	call .SelectMilkDrinkRecipient ; select pokemon
	jr c, .skip
	ld a, b
	ld [wCurPartyMon], a
	call IsMonFainted
	call GetOneFifthMaxHP
	call RemoveHP
	push bc
	call HealHP_SFX_GFX
	pop bc
	call GetOneFifthMaxHP
	ld a, c
	ld [wCurPartyMon], a
	call IsMonFainted
	call RestoreHealth
	call HealHP_SFX_GFX
	ld a, PARTYMENUTEXT_HEAL_HP
	call ItemActionText
	call JoyWaitAorB
.skip
	ld a, b
	inc a
	ld [wPartyMenuCursor], a
	ret

.SelectMilkDrinkRecipient: ; f419 (3:7419)
.loop
	push bc
	ld a, PARTYMENUACTION_HEALING_ITEM
	ld [PartyMenuActionText], a
	call ChoosePkmnToUseItemOn
	pop bc
	jr c, .set_carry
	ld a, [wPartyMenuCursor]
	dec a
	ld c, a
	ld a, b
	cp c
	jr z, .cant_use ; chose the same mon as user
	ld a, c
	ld [wCurPartyMon], a
	call IsMonFainted
	jr z, .cant_use
	call IsMonAtFullHealth
	jr nc, .cant_use
	xor a
	ret

.set_carry
	scf
	ret

.cant_use
	push bc
	ld hl, .Text_CantBeUsed
	call MenuTextBoxBackup
	pop bc
	jr .loop
; f44a (3:744a)

.Text_CantBeUsed: ; 0xf44a
	; That can't be used on this #MON.
	text_jump UnknownText_0x1c5bac
	db "@"
; 0xf44f


EscapeRope: ; f44f
	xor a
	ld [wItemEffectSucceeded], a
	farcall EscapeRopeFunction

	ld a, [wItemEffectSucceeded]
	cp 1
	call z, UseDisposableItem
	ret
; f462


SuperRepel: ; f462
	ld b, 200 / 2
	jr UseRepel
; f466

MaxRepel: ; f466
	ld b, 300 / 2
	jr UseRepel
; f466

Repel: ; f46a
	ld b, 100 / 2
; f46c

UseRepel: ; f46c
	ld hl, wRepelEffect
	ld a, [hli]
	or [hl]
	ld hl, TextJump_RepelUsedEarlierIsStillInEffect
	jp nz, PrintText

	xor a
	sla b
	rla
	ld [wRepelEffect], a
	ld a, b
	ld [wRepelEffect + 1], a
	ld a, [wCurItem]
	ld [wRepelType], a

	jp UseItemText


TextJump_RepelUsedEarlierIsStillInEffect: ; 0xf47d
	; The REPEL used earlier is still in effect.
	text_jump Text_RepelUsedEarlierIsStillInEffect
	db "@"
; 0xf482


XAccuracy: ; f482
	ld hl, PlayerSubStatus4
	bit SUBSTATUS_X_ACCURACY, [hl]
	jp nz, WontHaveAnyEffect_NotUsedMessage
	set SUBSTATUS_X_ACCURACY, [hl]
	jp UseItemText
; f48f


PokeDoll: ; f48f
	ld a, [wBattleMode]
	dec a
	jr nz, .asm_f4a6
	inc a
	ld [wForcedSwitch], a
	ld a, [wBattleResult]
	and 3 << 6
	or $2
	ld [wBattleResult], a
	jp UseItemText

.asm_f4a6
	xor a
	ld [wItemEffectSucceeded], a
	ret
; f4ab


GuardSpec: ; f4ab
	ld hl, PlayerSubStatus4
	bit SUBSTATUS_MIST, [hl]
	jp nz, WontHaveAnyEffect_NotUsedMessage
	set SUBSTATUS_MIST, [hl]
	jp UseItemText
; f4b8


DireHit: ; f4b8
	ld hl, PlayerSubStatus4
	bit SUBSTATUS_FOCUS_ENERGY, [hl]
	jp nz, WontHaveAnyEffect_NotUsedMessage
	set SUBSTATUS_FOCUS_ENERGY, [hl]
	jp UseItemText
; f4c5


XAttack:
XDefend:
XSpeed:
XSpclAtk:
XSpclDef:; f4c5
	call UseItemText

	ld a, [wCurItem]
	ld hl, .x_item_table

.loop
	cp [hl]
	jr z, .got_it
	inc hl
	inc hl
	jr .loop

.got_it
	inc hl
	ld b, [hl]
	xor a
	ld [hBattleTurn], a
	ld [AttackMissed], a
	ld [EffectFailed], a
	farcall CheckIfStatCanBeRaised
	call WaitSFX

	farcall BattleCommand_StatUpMessage
	farcall BattleCommand_StatUpFailText

	ld a, [CurBattleMon]
	ld [wCurPartyMon], a
	ld c, HAPPINESS_USEDXITEM
	farcall ChangeHappiness
	ret
; f504

.x_item_table ; f504
    db X_ATTACK,   $10 | ATTACK
    db X_DEFEND,   $10 | DEFENSE
    db X_SPEED,    $10 | SPEED
    db X_SPCL_ATK, $10 | SP_ATTACK
	db X_SPCL_DEF, $10 | SP_DEFENSE
; f50c

PokeFlute: ; f50c
    farcall _PokeFlute
    ret

CoinCase: ; f59a
	ld hl, .coincasetext
	jp MenuTextBoxWaitButton

.coincasetext
	text_jump UnknownText_0x1c5c7b
	db "@"
; f5a5

ShellBox: ; f59a
	ld hl, .shellboxtext
	jp MenuTextBoxWaitButton

.shellboxtext
	text_jump ShellBoxText
	db "@"
; f5a5


ExpAll:
	ld hl, StatusFlags
	bit 4, [hl] ; exp all
	jr z, .off
	res 4, [hl]
	ld hl, .turnofftext
	jp MenuTextBoxWaitButton

.off:
	set 4, [hl]
	ld hl, .turnontext
	jp MenuTextBoxWaitButton

.turnofftext
	text_jump Text_TurnOffExpAll
	db "@"

.turnontext
	text_jump Text_TurnOnExpAll
	db "@"


OldRod: ; f5a5
	ld e, $0
	jr UseRod
; f5a9

GoodRod: ; f5a9
	ld e, $1
	jr UseRod
; f5ad

SuperRod: ; f5ad
	ld e, $2
	jr UseRod
; f5b1

MasterRod:
	ld e, $3
	; fallthrough

UseRod: ; f5b1
	farcall FishFunction
	ret
; f5b8


Itemfinder: ; f5b8
	farcall ItemFinder
	ret
; f5bf


MaxElixer:
PPUp:
PPMax:
Ether:
MaxEther:
Elixer:
Mysteryberry: ; f5bf
	ld a, [wCurItem]
	ld [wd002], a

.loop
	; Party Screen opens to choose on which Pkmn to use the Item
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
	jp c, PPRestoreItem_Cancel

.loop2
	ld a, [wd002]
	cp MAX_ELIXER
	jp z, Elixer_RestorePPofAllMoves
	cp ELIXER
	jp z, Elixer_RestorePPofAllMoves

	ld hl, TextJump_RaiseThePPOfWhichMove
	ld a, [wd002]
	cp PP_UP
	jr z, .ppup
	cp PP_MAX
	jr z, .ppup
	ld hl, TextJump_RestoreThePPOfWhichMove

.ppup
	call PrintText

	ld a, [CurMoveNum]
	push af
	xor a
	ld [CurMoveNum], a
	ld a, $2
	ld [wMoveSelectionMenuType], a
	farcall MoveSelectionScreen
	pop bc

	ld a, b
	ld [CurMoveNum], a
	jr nz, .loop
	ld hl, PartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetMthMoveOfNthPartymon

	push hl
	ld a, [hl]
	ld [wd265], a
	call GetMoveName
	call CopyName1
	pop hl

	ld a, [wd002]
	cp PP_UP
	jr z, .ppup2
	cp PP_MAX
	jp nz, Not_PP_Up

	ld bc, $0015
	add hl, bc
	ld a, [hl]
	cp 3 << 6 ; have 3 PP Ups already been used?
	jr c, .do_ppup
	
.ppup2
	ld a, [hl]
	cp SKETCH
	jr z, .CantUsePPUpOnSketch

	ld bc, MON_PP - MON_MOVES
	add hl, bc
	ld a, [hl]
	cp 3 << 6 ; have 3 PP Ups already been used?
	jr c, .do_ppup

.CantUsePPUpOnSketch:
.pp_is_maxed_out
	ld hl, TextJump_PPIsMaxedOut
	call PrintText
	jr .loop2

.do_ppup
	ld a, [wd002]
	cp PP_MAX
	jr nz, .not_pp_max
	ld a, [hl]
	or 3 << 6 ; maximize PP Up count
	jr .raised_pp
.not_pp_max
	ld a, [hl]
	add 1 << 6 ; increase PP Up count by 1
.raised_pp
	ld [hl], a
	ld a, $1
	ld [wd265], a
	call ApplyPPUp
	call Play_SFX_FULL_HEAL

	ld hl, TextJump_PPsIncreased
	ld a, [wd002]
	cp PP_UP
	jr z, .ppup3
	ld hl, TextJump_PPsMaximized
.ppup3
	call PrintText

FinishPPRestore: ; f64c
	call ClearPalettes
	jp UseDisposableItem
; f652

BattleRestorePP: ; f652
	ld a, [wBattleMode]
	and a
	jr z, .not_in_battle
	ld a, [wCurPartyMon]
	ld b, a
	ld a, [CurBattleMon]
	cp b
	jr nz, .not_in_battle
	ld a, [PlayerSubStatus5]
	bit SUBSTATUS_TRANSFORMED, a
	jr nz, .not_in_battle
	call .UpdateBattleMonPP

.not_in_battle
	call Play_SFX_FULL_HEAL
	ld hl, UnknownText_0xf739
	call PrintText
	jr FinishPPRestore

.UpdateBattleMonPP:
	ld a, [wCurPartyMon]
	ld hl, PartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	ld de, BattleMonMoves
	ld b, NUM_MOVES
.loop
	ld a, [de]
	and a
	ret z
	cp [hl]
	jr nz, .next
	push hl
	push de
	push bc
	rept NUM_MOVES + 2 ; BattleMonPP - BattleMonMoves
	inc de
	endr
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	ld a, [hl]
	ld [de], a
	pop bc
	pop de
	pop hl

.next
	inc hl
	inc de
	dec b
	jr nz, .loop
	ret
; f6a7

Not_PP_Up: ; f6a7
	call RestorePP
	jr nz, BattleRestorePP
	jp PPRestoreItem_NoEffect
; f6af

Elixer_RestorePPofAllMoves: ; f6af
	xor a
	ld hl, wMenuCursorY
	ld [hli], a
	ld [hl], a
	ld b, NUM_MOVES
.moveLoop
	push bc
	ld hl, PartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetMthMoveOfNthPartymon
	ld a, [hl]
	and a
	jr z, .next

	call RestorePP
	jr z, .next
	ld hl, wMenuCursorX
	inc [hl]

.next
	ld hl, wMenuCursorY
	inc [hl]
	pop bc
	dec b
	jr nz, .moveLoop
	ld a, [wMenuCursorX]
	and a
	jp nz, BattleRestorePP

PPRestoreItem_NoEffect: ; f6dd
	call WontHaveAnyEffectMessage

PPRestoreItem_Cancel: ; f6e0
	call ClearPalettes
	xor a
	ld [wItemEffectSucceeded], a
	ret
; f6e8

RestorePP: ; f6e8
	xor a ; PARTYMON
	ld [MonType], a
	call GetMaxPPOfMove
	ld hl, PartyMon1PP
	ld bc, PARTYMON_STRUCT_LENGTH
	call GetMthMoveOfNthPartymon
	ld a, [wd265]
	ld b, a
	ld a, [hl]
	and (1 << 6) - 1
	cp b
	jr nc, .dont_restore

	ld a, [wd002]
	cp MAX_ELIXER
	jr z, .restore_all
	cp MAX_ETHER
	jr z, .restore_all

	ld c, 5
	cp MYSTERYBERRY
	jr z, .restore_some

	ld c, 10

.restore_some
	ld a, [hl]
	and (1 << 6) - 1
	add c
	cp b
	jr nc, .restore_all
	ld b, a

.restore_all
	ld a, [hl]
	and 3 << 6
	or b
	ld [hl], a
	ret

.dont_restore
	xor a
	ret
; f725

TextJump_RaiseThePPOfWhichMove: ; 0xf725
	; Raise the PP of which move?
	text_jump Text_RaiseThePPOfWhichMove
	db "@"
; 0xf72a

TextJump_RestoreThePPOfWhichMove: ; 0xf72a
	; Restore the PP of which move?
	text_jump Text_RestoreThePPOfWhichMove
	db "@"
; 0xf72f

TextJump_PPIsMaxedOut: ; 0xf72f
	; 's PP is maxed out.
	text_jump Text_PPIsMaxedOut
	db "@"
; 0xf734

TextJump_PPsIncreased: ; 0xf734
	; 's PP increased.
	text_jump Text_PPsIncreased
	db "@"
; 0xf739

TextJump_PPsMaximized:
	; 's PP maximized.
	text_jump Text_PPsMaximized
	db "@"

UnknownText_0xf739: ; 0xf739
	; PP was restored.
	text_jump UnknownText_0x1c5cf1
	db "@"
; 0xf73e


Squirtbottle: ; f73e
	farcall _Squirtbottle
	ret
; f745


SacredAsh: ; f753
	farcall _SacredAsh
	ld a, [wItemEffectSucceeded]
	cp $1
	ret nz
	jp UseDisposableItem
; f763


PinkanBerry:
; Choose a Pokémon to use it on
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; Exit early if the player canceled
	jr c, PinkanBerry_ExitMenu

; Pinkan Berry has no effect on already-pink mons
	ld a, MON_PINK
	call GetPartyParamLocation
	ld a, [hl]
	and PINK_MASK
	jp nz, NoEffectMessage

; Make it pink
	ld a, [hl]
	or PINK_MASK
	ld [hl], a

; Make it pink in battle (new section)
	call IsItemUsedOnBattleMon
	jr nc, .not_in_battle
	ld hl, BattleMonPink
	ld a, [hl]
	or PINK_MASK
	ld [hl], a
.not_in_battle

; Play a sound effect
	call Play_SFX_FULL_HEAL

; Describe the effect
	ld a, PARTYMENUTEXT_MAKE_PINK
	ld [PartyMenuActionText], a
	call ItemActionTextWaitButton
; Use up the Pinkan Berry
	call UseDisposableItem
	jp ClearPalettes

PinkCure:
; Choose a Pokémon to use it on
	ld b, PARTYMENUACTION_HEALING_ITEM
	call UseItem_SelectMon
; Exit early if the player canceled
	jr c, PinkCure_ExitMenu

; Pink Cure has no effect on not-pink mons
	ld a, MON_PINK
	call GetPartyParamLocation
	ld a, [hl]
	and PINK_MASK
	jp z, NoEffectMessage

; Make it not pink
	ld a, [hl]
	and $ff - PINK_MASK
	ld [hl], a

; Make it not pink in battle (new section)
	call IsItemUsedOnBattleMon
	jr nc, .not_in_battle
	ld hl, BattleMonPink
	ld a, [hl]
	and $ff - PINK_MASK
	ld [hl], a
.not_in_battle

; Play a sound effect
	call Play_SFX_FULL_HEAL

; Describe the effect
	ld a, PARTYMENUTEXT_MAKE_NOT_PINK
	ld [PartyMenuActionText], a
	call ItemActionTextWaitButton
; Use up the Pink Cure
	call UseDisposableItem
	jp ClearPalettes

PinkanBerry_ExitMenu:
PinkCure_ExitMenu:
; wItemEffectSucceeded of 0 means it was canceled
; it's set to 1 by default before calling PinkanBerry
	xor a
	ld [wItemEffectSucceeded], a
	jp ClearPalettes

Brightpowder:
LuckyPunch:
MetalPowder:
Nugget:
SilverWing:
QuickClaw:
SoftSand:
SharpBeak:
PoisonBarb:
KingsRock:
Tinymushroom:
BigMushroom:
Silverpowder:
AmuletCoin:
CleanseTag:
MysticWater:
Twistedspoon:
Blackbelt:
Blackglasses:
PinkBow:
Stick:
SmokeBall:
Nevermeltice:
Magnet:
Pearl:
BigPearl:
Everstone:
SpellTag:
GSBall:
MiracleSeed:
ThickClub:
FocusBand:
HardStone:
LuckyEgg:
Stardust:
StarPiece:
Charcoal:
ScopeLens:
MetalCoat:
DragonFang:
Leftovers:
DragonScale:
BerserkGene:
FlowerMail:
LightBall:
PolkadotBow:
RainbowWing:
MoroTrophy:
ShinyCharm:
SoulDew:
HeartScale:
QuickPowder:
SalveyoWeed:
CatStatue: ; f77d
	jp IsntTheTimeMessage
; f780


Play_SFX_FULL_HEAL: ; f780
	push de
	ld de, SFX_FULL_HEAL
	call WaitPlaySFX
	pop de
	ret
; f789

UseItemText: ; f789
	ld hl, UsedItemText
	call PrintText
	call Play_SFX_FULL_HEAL
	call WaitPressAorB_BlinkCursor
UseDisposableItem: ; f795
	ld hl, NumItems
	ld a, 1
	ld [wItemQuantityChangeBuffer], a
	jp TossItem
; f7a0

UseBallInTrainerBattle: ; f7a0
	call ReturnToBattle_UseBall
	ld de, ANIM_THROW_POKE_BALL
	ld a, e
	ld [FXAnimIDLo], a
	ld a, d
	ld [FXAnimIDHi], a
	xor a
	ld [wBattleAnimParam], a
	ld [hBattleTurn], a
	ld [wNumHits], a
	predef PlayBattleAnim
	ld hl, BlockedTheBallText
	call PrintText
	ld hl, DontBeAThiefText
	call PrintText
	jr UseDisposableItem
; f7ca

WontHaveAnyEffect_NotUsedMessage: ; f7ca
	ld hl, WontHaveAnyEffectText
	call PrintText

	; Item wasn't used.
	ld a, $2
	ld [wItemEffectSucceeded], a
	ret
; f7d6

LooksBitterMessage: ; f7d6
	ld hl, LooksBitterText
	jp PrintText
; f7dc

Ball_BoxIsFullMessage: ; f7dc
	ld hl, Ball_BoxIsFullText
	call PrintText

	; Item wasn't used.
	ld a, $2
	ld [wItemEffectSucceeded], a
	ret
; f7e8

CantUseOnEggMessage: ; f7e8
	ld hl, CantUseOnEggText
	jr CantUseItemMessage

IsntTheTimeMessage: ; f7ed
	ld hl, IsntTheTimeText
	jr CantUseItemMessage

WontHaveAnyEffectMessage: ; f7f2
	ld hl, WontHaveAnyEffectText

CantUseItemMessage: ; f804
; Item couldn't be used.
	xor a
	ld [wItemEffectSucceeded], a
	jp PrintText
; f80b

LooksBitterText: ; 0xf80b
	; It looks bitter…
	text_jump UnknownText_0x1c5d3e
	db "@"
; 0xf810

CantUseOnEggText: ; 0xf810
	; That can't be used on an EGG.
	text_jump UnknownText_0x1c5d50
	db "@"
; 0xf815

IsntTheTimeText: ; 0xf815
	; OAK:  ! This isn't the time to use that!
	text_jump UnknownText_0x1c5d6e
	db "@"
; 0xf81a

WontHaveAnyEffectText: ; 0xf81f
	; It won't have any effect.
	text_jump UnknownText_0x1c5db6
	db "@"
; 0xf824

BlockedTheBallText: ; 0xf824
	; The trainer blocked the BALL!
	text_jump UnknownText_0x1c5dd0
	db "@"
; 0xf829

DontBeAThiefText: ; 0xf829
	; Don't be a thief!
	text_jump UnknownText_0x1c5def
	db "@"
; 0xf82e

Ball_BoxIsFullText: ; 0xf838
	; The #MON BOX is full. That can't be used now.
	text_jump UnknownText_0x1c5e3a
	db "@"
; 0xf83d

UsedItemText: ; 0xf83d
	; used the@ .
	text_jump UnknownText_0x1c5e68
	db "@"
; 0xf842

ApplyPPUp: ; f84c
	ld a, MON_MOVES
	call GetPartyParamLocation
	push hl
	ld de, Buffer1
	predef FillPP
	pop hl
	ld bc, MON_PP - MON_MOVES
	add hl, bc
	ld de, Buffer1
	ld b, 0
.loop
	inc b
	ld a, b
	cp NUM_MOVES + 1
	ret z
	ld a, [wd265]
	dec a
	jr nz, .use
	ld a, [wMenuCursorY]
	inc a
	cp b
	jr nz, .skip

.use
	ld a, [hl]
	and 3 << 6
	ld a, [de] ; wasted cycle
	call nz, ComputeMaxPP

.skip
	inc hl
	inc de
	jr .loop
; f881



ComputeMaxPP: ; f881
	push bc
	; Divide the base PP by 5.
	ld a, [de]
	ld [hDividend + 3], a
	xor a
	ld [hDividend], a
	ld [hDividend + 1], a
	ld [hDividend + 2], a
	ld a, 5
	ld [hDivisor], a
	ld b, 4
	call Divide
	; Get the number of PP, which are bits 6 and 7 of the PP value stored in RAM.
	ld a, [hl]
	ld b, a
	swap a
	and $f
	srl a
	srl a
	ld c, a
	; If this value is 0, we are done
	and a
	jr z, .NoPPUp

.loop
	; Normally, a move with 40 PP would have 64 PP with three PP Ups.
	; Since this would overflow into bit 6, we prevent that from happening
	; by decreasing the extra amount of PP each PP Up provides, resulting
	; in a maximum of 61.
	ld a, [hQuotient + 2]
	cp $8
	jr c, .okay
	ld a, $7

.okay
	add b
	ld b, a
	ld a, [wd265]
	dec a
	jr z, .NoPPUp
	dec c
	jr nz, .loop

.NoPPUp:
	ld [hl], b
	pop bc
	ret
; f8b9

RestoreAllPP: ; f8b9
	ld a, MON_PP
	call GetPartyParamLocation
	push hl
	ld a, MON_MOVES
	call GetPartyParamLocation
	pop de
	xor a ; PARTYMON
	ld [wMenuCursorY], a
	ld [MonType], a
	ld c, NUM_MOVES
.loop
	ld a, [hli]
	and a
	ret z
	push hl
	push de
	push bc
	call GetMaxPPOfMove
	pop bc
	pop de
	ld a, [de]
	and 3 << 6
	ld b, a
	ld a, [wd265]
	add b
	ld [de], a
	inc de
	ld hl, wMenuCursorY
	inc [hl]
	pop hl
	dec c
	jr nz, .loop
	ret
; f8ec


GetMaxPPOfMove: ; f8ec
	ld a, [StringBuffer1 + 0]
	push af
	ld a, [StringBuffer1 + 1]
	push af

	ld a, [MonType]
	and a

	ld hl, PartyMon1Moves
	ld bc, PARTYMON_STRUCT_LENGTH
	jr z, .got_partymon ; PARTYMON

	ld hl, OTPartyMon1Moves
	dec a
	jr z, .got_partymon ; OTPARTYMON

	ld hl, TempMonMoves
	dec a
	jr z, .got_nonpartymon ; BOXMON

	ld hl, TempMonMoves ; Wasted cycles
	dec a
	jr z, .got_nonpartymon ; TEMPMON

	ld hl, BattleMonMoves ; WILDMON

.got_nonpartymon ; BOXMON, TEMPMON, WILDMON
	call GetMthMoveOfCurrentMon
	jr .gotdatmove

.got_partymon ; PARTYMON, OTPARTYMON
	call GetMthMoveOfNthPartymon

.gotdatmove
	ld a, [hl]
	dec a

	push hl
	ld hl, Moves + MOVE_PP
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld a, BANK(Moves)
	call GetFarByte
	ld b, a
	ld de, StringBuffer1
	ld [de], a
	pop hl

	push bc
	ld bc, MON_PP - MON_MOVES
	ld a, [MonType]
	cp WILDMON
	jr nz, .notwild
	ld bc, EnemyMonPP - EnemyMonMoves
.notwild
	add hl, bc
	ld a, [hl]
	and 3 << 6
	pop bc

	or b
	ld hl, StringBuffer1 + 1
	ld [hl], a
	xor a
	ld [wd265], a
	ld a, b ; this gets lost anyway
	call ComputeMaxPP
	ld a, [hl]
	and (1 << 6) - 1
	ld [wd265], a

	pop af
	ld [StringBuffer1 + 1], a
	pop af
	ld [StringBuffer1 + 0], a
	ret
; f963

GetMthMoveOfNthPartymon: ; f963
	ld a, [wCurPartyMon]
	call AddNTimes

GetMthMoveOfCurrentMon: ; f969
	ld a, [wMenuCursorY]
	ld c, a
	ld b, 0
	add hl, bc
	ret
; f971

INCLUDE "items/pokeball_wobble.asm"
