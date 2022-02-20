# Copyright (c) 2021 Mike "KemoNine" Crosson
# SPDX-License-Identifier: Apache-2.0

###########
# Fundamental Config
COMBO_ENABLE = yes
COMMAND_ENABLE = no
CONSOLE_ENABLE = no
EXTRAKEY_ENABLE = yes
MOUSEKEY_ENABLE = yes
NKRO_ENABLE = yes
SPACE_CADET_ENABLE = no
TERMINAL_ENABLE = no
VIA_ENABLE = no

##########
# Enable LTO if possible (graphics on avr mainly)
ifneq ($(PLATFORM),CHIBIOS)
    ifneq ($(strip $(LTO_SUPPORTED)), no)
        LTO_ENABLE = yes
    endif
endif

##########
# Combo engine related
VPATH += keyboards/gboards/

###########
# ARTSEY Sources
SRC += artsey.c

##########
# Set size for all build steps
ifeq ($(strip $(ARTSEY_SIZE)), std)
	ARTSEY_SIZE_STD = yes
	OPT_DEFS += -DARTSEY_SIZE_STD
endif
ifeq ($(strip $(ARTSEY_SIZE)), big)
	ARTSEY_SIZE_BIG = yes
	OPT_DEFS += -DARTSEY_SIZE_BIG
endif
ifeq ($(strip $(ARTSEY_SIZE)), 40p)
	ARTSEY_SIZE_40P = yes
	OPT_DEFS += -DARTSEY_SIZE_40P
endif

##########
# Set handedness for all build steps
ifeq ($(strip $(ARTSEY_HAND)), left)
	ARTSEY_HAND_LEFT = yes
	OPT_DEFS += -DARTSEY_HAND_LEFT
endif
ifeq ($(strip $(ARTSEY_HAND)), right)
	ARTSEY_HAND_RIGHT = yes
	OPT_DEFS += -DARTSEY_HAND_RIGHT
endif

##########
# User tunable timings
ifndef TAPPING_TERM
	TAPPING_TERM = 200
endif
ifndef COMBO_TERM
	COMBO_TERM = 300
endif
OPT_DEFS += -DTAPPING_TERM=$(TAPPING_TERM) -DCOMBO_TERM=$(COMBO_TERM)


##########
# Set remix for all build steps
ifeq ($(strip $(ARTSEY_REMIX)), yes)
	ARTSEY_REMIX = yes
	OPT_DEFS += -DARTSEY_REMIX
endif

##########
# Tap dance for 40% ARTSEY
ifeq ($(ARTSEY_SIZE_40P), yes)
	TAP_DANCE_ENABLE = yes
	SRC += layout/tap_dance.c
endif

##########
# 5 column flag for 40% ARTSEY
ifeq ($(KEYBOARD), $(filter $(KEYBOARD), draculad ferris/sweep))
	ARTSEY_FIVE_COLUMN = yes
	OPT_DEFS += -DARTSEY_FIVE_COLUMN
endif

##########
# 2 thumb flag
ifeq ($(KEYBOARD), $(filter $(KEYBOARD), ferris/sweep))
	ARTSEY_TWO_THUMB = yes
	OPT_DEFS += -DARTSEY_TWO_THUMB
endif

##########
# Pimoroni support
ifeq ($(ARTSEY_PIMORONI), yes)
	SRC += layout/pimoroni.c
	POINTING_DEVICE_ENABLE = yes
	POINTING_DEVICE_DRIVER = pimoroni_trackball
ifndef PIMORONI_BRIGHTNESS
	PIMORONI_BRIGHTNESS = 127
endif
ifndef PIMORONI_RGB
	PIMORONI_RGB 255,255,255
endif
	OPT_DEFS += -DPIMORONI_BRIGHTNESS=$(PIMORONI_BRIGHTNESS) -DPIMORONI_RGB=$(PIMORONI_RGB)
endif

##########
# OLED enable based on board support
ifndef OLED_ENABLE
ifeq ($(KEYBOARD), $(filter $(KEYBOARD), artsey/thepaintbrush crkbd/rev1 ristretto))
    OLED_ENABLE = yes
else
	OLED_ENABLE = no
endif
endif
ifeq ($(OLED_ENABLE), yes)
ifndef OLED_BRIGHTNESS
	OLED_BRIGHTNESS = 127
endif
ifndef ARTSEY_BOOT_LOGO_TIMEOUT
	ARTSEY_BOOT_LOGO_TIMEOUT = 2000
endif
ifndef ARTSEY_OLED_ICON
	ARTSEY_OLED_ICON = badslime_1
endif
	SRC += oled/oled.c
	OPT_DEFS += -DOLED_ENABLE -DOLED_BRIGHTNESS=$(OLED_BRIGHTNESS) -DARTSEY_BOOT_LOGO_TIMEOUT=$(ARTSEY_BOOT_LOGO_TIMEOUT) -DARTSEY_OLED_ICON=icon_$(ARTSEY_OLED_ICON)
ifeq ($(ARTSEY_BOOT_LOGO), no)
else
	OPT_DEFS += -DARTSEY_BOOT_LOGO
endif
ifeq ($(KEYBOARD), $(filter $(KEYBOARD), artsey/thepaintbrush crkbd/rev1 ristretto))
    OPT_DEFS += -DOLED_DRIVER=SSD1306
endif
endif
