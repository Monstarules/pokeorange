; Replaces the functionality of sgb.asm to work with CGB hardware.

Predef_LoadSGBLayoutCGB: ; 8d59
	ld a, b
	cp SCGB_RAM
	jr nz, .not_ram
	ld a, [SGBPredef]
.not_ram
	cp SCGB_PARTY_MENU_HP_PALS
	jp z, CGB_ApplyPartyMenuHPPals
	call ResetBGPals
	ld l, a
	ld h, 0
	add hl, hl
	ld de, .dw
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, .ReturnFromJumpTable
	push de
	jp hl
; 8d79

.ReturnFromJumpTable: ; 8d79
	ret
; 8d7a

.dw ; 8d7a
	dw _CGB_BattleGrayscale
	dw _CGB_BattleColors
	dw _CGB_PokegearPals
	dw _CGB_StatsScreenHPPals
	dw _CGB_Pokedex
	dw _CGB_SlotMachine
	dw _CGB_Diploma
	dw _CGB_MapPals
	dw _CGB_PartyMenu
	dw _CGB_Evolution
	dw _CGB_MoveList
	dw _CGB_PokedexSearchOption
	dw _CGB_Pokepic
	dw _CGB_PackPals
	dw _CGB_TrainerCard
	dw _CGB_BillsPC
	dw _CGB_GamefreakLogo ; called before copyright
	dw _CGB_PlayerOrMonFrontpicPals
	dw _CGB_TradeTube
	dw _CGB_TrainerOrMonFrontpicPals
; 8db8

_CGB_BattleGrayscale: ; 8db8
	ld hl, PalPacket_Grayscale
	ld de, UnknBGPals
	ld c, $4
	call CopyPalettes
	ld hl, PalPacket_Grayscale
	ld de, UnknBGPals + 4 palettes
	ld c, $4
	call CopyPalettes
	ld hl, PalPacket_Grayscale
	ld de, UnknOBPals
	ld c, $2
	call CopyPalettes
	jr _CGB_FinishBattleScreenLayout

_CGB_BattleColors: ; 8ddb
	ld de, UnknBGPals
	call GetBattlemonBackpicPalettePointer
	push hl
	call LoadPalette_White_Col1_Col2_Black
	call GetEnemyFrontpicPalettePointer
	push hl
	call LoadPalette_White_Col1_Col2_Black
	ld a, [EnemyHPPal]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, HPBarPals
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld a, [PlayerHPPal]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, HPBarPals
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld hl, ExpBarPalette
	call LoadPalette_White_Col1_Col2_Black
	ld de, UnknOBPals
	pop hl
	call LoadPalette_White_Col1_Col2_Black
	pop hl
	call LoadPalette_White_Col1_Col2_Black
	ld a, SCGB_BATTLE_COLORS
	ld [SGBPredef], a
	call ApplyPals
_CGB_FinishBattleScreenLayout: ; 8e23
	call InitPartyMenuBGPal7
	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, $2
	call ByteFill
	hlcoord 0, 4, AttrMap
	lb bc, 8, 10
	ld a, $0
	call FillBoxCGB
	hlcoord 10, 0, AttrMap
	lb bc, 7, 10
	ld a, $1
	call FillBoxCGB
	hlcoord 0, 0, AttrMap
	lb bc, 4, 10
	ld a, $2
	call FillBoxCGB
	hlcoord 10, 7, AttrMap
	lb bc, 5, 10
	ld a, $3
	call FillBoxCGB
	hlcoord 10, 11, AttrMap
	lb bc, 1, 9
	ld a, $4
	call FillBoxCGB
	hlcoord 0, 12, AttrMap
	ld bc, 6 * SCREEN_WIDTH
	ld a, $7
	call ByteFill
	ld hl, BattleObjectPals
	ld de, UnknOBPals + 2 palettes
	ld bc, 6 palettes
	ld a, $5
	call FarCopyWRAM
	call ApplyAttrMap
	ret
; 8e85


InitPartyMenuBGPal7: ; 8e85
	ld hl, PartyMenuBGPalette
	ld de, UnknBGPals + 8 * 7
	ld bc, 1 palettes
	ld a, $5
	call FarCopyWRAM
	ret
; 8e9f

InitPartyMenuBGPal0: ; 8e9f
	ld hl, PartyMenuBGPalette
	ld de, UnknBGPals
	ld bc, 1 palettes
	ld a, $5
	call FarCopyWRAM
	ret
; 8eb9

_CGB_PokegearPals: ; 8eb9
	ld a, [PlayerGender]
	bit 0, a
	jr z, .male
	ld hl, FemalePokegearPals
	jr .got_pals

.male
	ld hl, MalePokegearPals
.got_pals
	ld de, UnknBGPals
	ld bc, 6 palettes
	ld a, $5
	call FarCopyWRAM
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8edb

_CGB_StatsScreenHPPals: ; 8edb
	ld de, UnknBGPals
	ld a, [wcda1]
	ld l, a
	ld h, $0
	add hl, hl
	add hl, hl
	ld bc, HPBarPals
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	ld a, [CurPartySpecies]
	ld bc, TempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld hl, ExpBarPalette
	call LoadPalette_White_Col1_Col2_Black
	ld hl, Palette8f52
	ld de, UnknBGPals + 8 * 3
	ld bc, 3 palettes
	ld a, $5
	call FarCopyWRAM
	call WipeAttrMap

	hlcoord 0, 0, AttrMap
	lb bc, 8, SCREEN_WIDTH
	ld a, $1
	call FillBoxCGB

	hlcoord 10, 16, AttrMap
	ld bc, 10
	ld a, $2
	call ByteFill

	hlcoord 13, 5, AttrMap
	lb bc, 2, 2
	ld a, $3
	call FillBoxCGB

	hlcoord 15, 5, AttrMap
	lb bc, 2, 2
	ld a, $4
	call FillBoxCGB

	hlcoord 17, 5, AttrMap
	lb bc, 2, 2
	ld a, $5
	call FillBoxCGB

	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8f52

Palette8f52: ; 8f52
	RGB 31, 31, 31
	RGB 31, 19, 31
	RGB 31, 15, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 21, 31, 14
	RGB 17, 31, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 17, 31, 31
	RGB 17, 31, 31
	RGB 00, 00, 00
; 8f6a

StatsScreenPals: ; 8f6a
	RGB 31, 19, 31

	RGB 21, 31, 14

	RGB 17, 31, 31
; 8f70

_CGB_Pokedex: ; 8f70
	ld de, UnknBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [CurPartySpecies]
	cp $ff
	jr nz, .is_pokemon
	ld hl, Palette8fba
	call LoadHLPaletteIntoDE
	jr .got_palette

.is_pokemon
	call GetMonPalettePointer_
	call LoadPalette_White_Col1_Col2_Black
.got_palette
	call WipeAttrMap
	hlcoord 1, 1, AttrMap
	lb bc, 7, 7
	ld a, $1
	call FillBoxCGB
	call InitPartyMenuOBPals
	ld hl, Palette8fc2
	ld de, UnknOBPals + 7 palettes
	ld bc, 1 palettes
	ld a, $5
	call FarCopyWRAM
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 8fba

Palette8fba: ; 8fba
	RGB 27, 14, 02
	RGB 23, 12, 01
	RGB 23, 12, 01
	RGB 20, 10, 02

Palette8fc2: ; 8fc2
	RGB 00, 00, 00
	RGB 27, 14, 02
	RGB 23, 12, 01
	RGB 00, 00, 00
; 8fca

_CGB_BillsPC: ; 8fca
	ld de, UnknBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [CurPartySpecies]
	cp $ff
	jr nz, .GetMonPalette
	ld hl, Palette9036
	call LoadHLPaletteIntoDE
	jr .Resume

.GetMonPalette:
	ld bc, TempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
.Resume:
	call WipeAttrMap
	hlcoord 1, 4, AttrMap
	lb bc, 7, 7
	ld a, $1
	call FillBoxCGB
	call InitPartyMenuOBPals
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 9009

Function9009: ; 9009
	ld hl, Palette9036
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	hlcoord 1, 1, AttrMap
	lb bc, 7, 7
	ld a, $1
	call FillBoxCGB
	call InitPartyMenuOBPals
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 9036

Palette9036: ; 9036
	RGB 31, 15, 00
	RGB 23, 12, 00
	RGB 15, 07, 00
	RGB 00, 00, 00
; 903e

_CGB_SlotMachine: ; 906e
	ld hl, SlotMachinePals
	ld de, UnknBGPals
	ld bc, $80
	ld a, $5
	call FarCopyWRAM
	call WipeAttrMap
	hlcoord 0, 2, AttrMap
	lb bc, 10, 3
	ld a, $2
	call FillBoxCGB
	hlcoord 17, 2, AttrMap
	lb bc, 10, 3
	ld a, $2
	call FillBoxCGB
	hlcoord 0, 4, AttrMap
	lb bc, 6, 3
	ld a, $3
	call FillBoxCGB
	hlcoord 17, 4, AttrMap
	lb bc, 6, 3
	ld a, $3
	call FillBoxCGB
	hlcoord 0, 6, AttrMap
	lb bc, 2, 3
	ld a, $4
	call FillBoxCGB
	hlcoord 17, 6, AttrMap
	lb bc, 2, 3
	ld a, $4
	call FillBoxCGB
	hlcoord 4, 2, AttrMap
	lb bc, 2, 12
	ld a, $1
	call FillBoxCGB
	hlcoord 3, 2, AttrMap
	lb bc, 10, 1
	ld a, $1
	call FillBoxCGB
	hlcoord 16, 2, AttrMap
	lb bc, 10, 1
	ld a, $1
	call FillBoxCGB
	hlcoord 0, 12, AttrMap
	ld bc, $78
	ld a, $7
	call ByteFill
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 90f8

_CGB_Diploma: ; 91ad
	ld hl, DiplomaPalettes
	ld de, UnknBGPals
	ld bc, 16 palettes
	ld a, $5
	call FarCopyWRAM

	ld hl, PalPacket_Diploma
	call CopyFourPalettes
	call WipeAttrMap
	call ApplyAttrMap
	ret
; 91c8

_CGB_MapPals: ; 91c8
	call LoadMapPals
	ld a, SCGB_MAPPALS
	ld [SGBPredef], a
	ret
; 91d1

_CGB_PartyMenu: ; 91d1
	ld hl, PalPacket_PartyMenu
	call CopyFourPalettes
	call InitPartyMenuBGPal0
	call InitPartyMenuBGPal7
	call InitPartyMenuOBPals
	call ApplyAttrMap
	ret
; 91e4

_CGB_Evolution: ; 91e4
	ld de, UnknBGPals
	ld a, c
	and a
	jr z, .pokemon
	ld a, $1a
	call GetPredefPal
	call LoadHLPaletteIntoDE
	jr .got_palette

.pokemon
	ld hl, PartyMon1DVs
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, [CurPartyMon]
	call AddNTimes
	ld c, l
	ld b, h
	ld a, [PlayerHPPal]
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld hl, BattleObjectPals
	ld de, UnknOBPals + 2 palettes
	ld bc, 6 palettes
	ld a, $5
	call FarCopyWRAM

.got_palette
	call WipeAttrMap
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 9228

_CGB_TrainerCard: ; 9289
	ld de, UnknBGPals
	xor a
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $1
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $3
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $2
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $4
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $7
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $6
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $5
	call GetTrainerPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	ld a, $24
	call GetPredefPal
	call LoadHLPaletteIntoDE

	hlcoord 0, 0, AttrMap
	ld bc, SCREEN_WIDTH * SCREEN_HEIGHT
	ld a, [PlayerGender]
	and a
	ld a, $1
	jr z, .got_gender
	ld a, $0
.got_gender
	call ByteFill
	hlcoord 14, 1, AttrMap
	lb bc, 7, 5
	ld a, [PlayerGender]
	and a
	ld a, $0
	jr z, .got_gender2
	ld a, $1
.got_gender2
	call FillBoxCGB
	hlcoord 18, 1, AttrMap
	ld [hl], $1
	hlcoord 2, 11, AttrMap
	lb bc, 2, 4
	ld a, $1
	call FillBoxCGB
	hlcoord 6, 11, AttrMap
	lb bc, 2, 4
	ld a, $2
	call FillBoxCGB
	hlcoord 10, 11, AttrMap
	lb bc, 2, 4
	ld a, $3
	call FillBoxCGB
	hlcoord 14, 11, AttrMap
	lb bc, 2, 4
	ld a, $4
	call FillBoxCGB
	hlcoord 2, 14, AttrMap
	lb bc, 2, 4
	ld a, $5
	call FillBoxCGB
	hlcoord 6, 14, AttrMap
	lb bc, 2, 4
	ld a, $6
	call FillBoxCGB
	hlcoord 10, 14, AttrMap
	lb bc, 2, 4
	ld a, $7
	call FillBoxCGB
	ld a, [PlayerGender]
	and a
	push af
	jr z, .got_gender3
	hlcoord 14, 14, AttrMap
	lb bc, 2, 4
	ld a, $1
	call FillBoxCGB
.got_gender3
	pop af
	ld c, $0
	jr nz, .got_gender4
	inc c
.got_gender4
	ld a, c
	hlcoord 18, 1, AttrMap
	ld [hl], a
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 9373

_CGB_MoveList: ; 9373
	ld de, UnknBGPals
	ld a, $10
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld a, [PlayerHPPal]
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl
	ld bc, HPBarPals
	add hl, bc
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	hlcoord 11, 1, AttrMap
	lb bc, 2, 9
	ld a, $1
	call FillBoxCGB
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 93a6

_CGB_PokedexSearchOption: ; 93ba
	ld de, UnknBGPals
	ld a, $1d
	call GetPredefPal
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 93d3

_CGB_PackPals: ; 93d3
; pack pals
	ld a, [PlayerGender]
	bit 0, a
	jr z, .male
	ld hl, .KrisPackPals
	jr .got_gender
.male
	ld hl, .ChrisPackPals
.got_gender
	ld de, UnknBGPals
	ld bc, 8 palettes ; 6 palettes?
	ld a, $5
	call FarCopyWRAM
	call WipeAttrMap
	hlcoord 0, 0, AttrMap
	lb bc, 1, 10
	ld a, $1
	call FillBoxCGB
	hlcoord 10, 0, AttrMap
	lb bc, 1, 10
	ld a, $2
	call FillBoxCGB
	hlcoord 7, 2, AttrMap
	lb bc, 9, 1
	ld a, $3
	call FillBoxCGB
	hlcoord 0, 7, AttrMap
	lb bc, 3, 5
	ld a, $4
	call FillBoxCGB
	hlcoord 0, 3, AttrMap
	lb bc, 3, 5
	ld a, $5
	call FillBoxCGB
	call ApplyAttrMap
	call ApplyPals
	ld a, $1
	ld [hCGBPalUpdate], a
	ret
; 9439

.ChrisPackPals: ; 9439
	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 11, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 00, 00, 31
	RGB 31, 00, 00

	RGB 31, 31, 31
	RGB 15, 15, 31
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 19, 07
	RGB 07, 19, 07
	RGB 00, 00, 00
; 9469

.KrisPackPals: ; 9469
	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 15, 15, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 07, 31
	RGB 31, 00, 00

	RGB 31, 31, 31
	RGB 31, 14, 31
	RGB 31, 00, 00
	RGB 00, 00, 00

	RGB 31, 31, 31
	RGB 07, 19, 07
	RGB 07, 19, 07
	RGB 00, 00, 00
; 9499

_CGB_Pokepic: ; 9499
	call _CGB_MapPals
	ld de, SCREEN_WIDTH
	hlcoord 0, 0, AttrMap
	ld a, [wMenuBorderTopCoord]
.loop
	and a
	jr z, .found_top
	dec a
	add hl, de
	jr .loop

.found_top
	ld a, [wMenuBorderLeftCoord]
	ld e, a
	ld d, $0
	add hl, de
	ld a, [wMenuBorderTopCoord]
	ld b, a
	ld a, [wMenuBorderBottomCoord]
	inc a
	sub b
	ld b, a
	ld a, [wMenuBorderLeftCoord]
	ld c, a
	ld a, [wMenuBorderRightCoord]
	sub c
	inc a
	ld c, a
	ld a, $0
	call FillBoxCGB
	call ApplyAttrMap
	ret
; 94d0

_CGB_GamefreakLogo: ; 94fa
	ld de, UnknBGPals
	ld a, $4e
	call GetPredefPal
	call LoadHLPaletteIntoDE
	ld hl, .Palette
	ld de, UnknOBPals
	call LoadHLPaletteIntoDE
	ld hl, .Palette
	ld de, UnknOBPals + 1 palettes
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	call ApplyAttrMap
	call ApplyPals
	ret
; 9521

.Palette: ; 9521
	RGB 31, 31, 31
	RGB 13, 11, 00
	RGB 23, 12, 28
	RGB 00, 00, 00
; 9529

_CGB_PlayerOrMonFrontpicPals: ; 9529
	ld de, UnknBGPals
	ld a, [CurPartySpecies]
	ld bc, TempMonDVs
	call GetPlayerOrMonPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	call ApplyAttrMap
	call ApplyPals
	ret
; 9542

_CGB_TradeTube: ; 9555
	ld hl, PalPacket_TradeTube
	call CopyFourPalettes
	ld hl, PartyMenuOBPals
	ld de, UnknOBPals
	ld bc, 1 palettes
	ld a, $5
	call FarCopyWRAM
	ld de, UnknOBPals + 7 palettes
	ld a, $1c
	call GetPredefPal
	call LoadHLPaletteIntoDE
	call WipeAttrMap
	ret
; 9578

_CGB_TrainerOrMonFrontpicPals: ; 9578
	ld de, UnknBGPals
	ld a, [CurPartySpecies]
	ld bc, TempMonDVs
	call GetFrontpicPalettePointer
	call LoadPalette_White_Col1_Col2_Black
	call WipeAttrMap
	call ApplyAttrMap
	call ApplyPals
	ret
; 9591
