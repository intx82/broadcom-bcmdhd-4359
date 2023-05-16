# bcmdhd
#
# Copyright (C) 2023, Broadcom.
#
#      Unless you and Broadcom execute a separate written software license
# agreement governing use of this software, this software is licensed to you
# under the terms of the GNU General Public License version 2 (the "GPL"),
# available at http://www.broadcom.com/licenses/GPLv2.php, with the
# following added to such license:
#
#      As a special exception, the copyright holders of this software give you
# permission to link this software with independent modules, and to copy and
# distribute the resulting executable under terms of your choice, provided that
# you also meet, for each linked independent module, the terms and conditions of
# the license of that module.  An independent module is a module which is not
# derived from this software.  The special exception does not apply to any
# modifications of the software.
#
#
# <<Broadcom-WL-IPTag/Open:>>
#

MODULE_NAME := bcmdhd
CONFIG_BCMDHD ?= m

#CONFIG_BCMDHD_SDIO := y
#CONFIG_BCMDHD_PCIE := y
#CONFIG_BCMDHD_USB := y

#CONFIG_BCMDHD_OOB := y
#CONFIG_BCMDHD_CUSB := y
#CONFIG_BCMDHD_NO_POWER_OFF := y
CONFIG_BCMDHD_PROPTXSTATUS := y
CONFIG_DHD_USE_STATIC_BUF := y
CONFIG_BCMDHD_STATIC_BUF_IN_DHD := y
#CONFIG_BCMDHD_ANDROID_VERSION := 12
CONFIG_BCMDHD_AUTO_SELECT := y
CONFIG_BCMDHD_DEBUG := y
#CONFIG_BCMDHD_RECONNECT := y
#CONFIG_BCMDHD_TIMESTAMP := y
#CONFIG_BCMDHD_WAPI := y
#CONFIG_BCMDHD_RANDOM_MAC := y
#CONFIG_BCMDHD_REQUEST_FW := y
#CONFIG_BCMDHD_FW_SIGNATURE := y
#CONFIG_BCMDHD_DWDS := y

#CONFIG_BCMDHD_MULTIPLE_DRIVER := y
#CONFIG_BCMDHD_ADAPTER_INDEX := 0

CONFIG_MACH_PLATFORM := y
#CONFIG_BCMDHD_DTS := y

DHDCFLAGS = -Wall -Wstrict-prototypes -Wno-date-time                      \
	-Wno-maybe-uninitialized                                              \
	-Dlinux -DLINUX -DBCMDRIVER -DBCMUTILS_ERR_CODES                      \
	-DBCMDONGLEHOST -DBCMDMA32 -DBCMFILEIMAGE                             \
	-DDHDTHREAD -DDHD_DEBUG -DSHOW_EVENTS -DGET_OTP_MAC_ENABLE            \
	-DWIFI_ACT_FRAME -DARP_OFFLOAD_SUPPORT -DSUPPORT_PM2_ONLY             \
	-DPKTPRIO_OVERRIDE                                                    \
	-DKEEP_ALIVE -DPKT_FILTER_SUPPORT -DDHDTCPACK_SUPPRESS                \
	-DDHD_DONOT_FORWARD_BCMEVENT_AS_NETWORK_PKT -DOEM_ANDROID             \
	-DMULTIPLE_SUPPLICANT -DTSQ_MULTIPLIER -DMFP -DDHD_8021X_DUMP         \
	-DPOWERUP_MAX_RETRY=0 -DIFACE_HANG_FORCE_DEV_CLOSE -DWAIT_DEQUEUE     \
	-DUSE_NEW_RSPEC_DEFS                                                  \
	-DWL_EXT_IAPSTA -DWL_ESCAN -DCCODE_LIST -DSUSPEND_EVENT               \
	-DKEY_INSTALL_CHECK                                                   \
	-DENABLE_INSMOD_NO_FW_LOAD

DHDOFILES = aiutils.o siutils.o sbutils.o                                 \
	bcmutils.o bcmwifi_channels.o bcmxtlv.o bcm_app_utils.o bcmstdlib_s.o \
	dhd_linux.o dhd_linux_platdev.o dhd_linux_sched.o dhd_pno.o           \
	dhd_common.o dhd_ip.o dhd_linux_wq.o dhd_custom_gpio.o                \
	bcmevent.o hndpmu.o linux_osl.o wldev_common.o wl_android.o           \
	dhd_debug_linux.o dhd_debug.o dhd_mschdbg.o dhd_dbg_ring.o            \
	hnd_pktq.o hnd_pktpool.o linux_pkt.o frag.o                           \
	dhd_linux_exportfs.o dhd_linux_pktdump.o dhd_mschdbg.o linuxerrmap.o  \
	dhd_linux_tx.o dhd_linux_rx.o fwpkg_utils.o                           \
	dhd_config.o dhd_ccode.o wl_event.o wl_android_ext.o                  \
	wl_iapsta.o wl_escan.o wl_timer.o

ifneq ($(CONFIG_WIRELESS_EXT),)
	DHDOFILES += wl_iw.o
	DHDCFLAGS += -DSOFTAP -DWL_WIRELESS_EXT -DUSE_IW
endif
ifneq ($(CONFIG_CFG80211),)
	DHDOFILES += wl_cfg80211.o wl_cfgscan.o wl_cfgp2p.o
	DHDOFILES += wl_linux_mon.o wl_cfg_btcoex.o wl_cfgvendor.o
	DHDOFILES += dhd_cfg80211.o wl_cfgvif.o wl_roam.o
	DHDCFLAGS += -DWL_CFG80211 -DWLP2P -DWL_CFG80211_STA_EVENT
	DHDCFLAGS += -DWL_CFG80211_GON_COLLISION
	DHDCFLAGS += -DWL_CAP_HE -DWL_6G_BAND -DWL_5P9G
#	DHDCFLAGS += -DCONFIG_6GHZ_BKPORT
	DHDCFLAGS += -DWL_IFACE_COMB_NUM_CHANNELS
	DHDCFLAGS += -DCUSTOM_PNO_EVENT_LOCK_xTIME=10
	DHDCFLAGS += -DWL_SUPPORT_AUTO_CHANNEL
	DHDCFLAGS += -DWL_SUPPORT_BACKPORTED_KPATCHES
	DHDCFLAGS += -DESCAN_RESULT_PATCH -DESCAN_BUF_OVERFLOW_MGMT
	DHDCFLAGS += -DVSDB -DWL_CFG80211_VSDB_PRIORITIZE_SCAN_REQUEST
	DHDCFLAGS += -DWLTDLS -DMIRACAST_AMPDU_SIZE=8
#    DHDCFLAGS += -DHOSTAPD_BW_SUPPORT
	DHDCFLAGS += -DWL_VIRTUAL_APSTA -DSTA_MGMT -DSOFTAP_UAPSD_OFF
	DHDCFLAGS += -DNUM_SCB_MAX_PROBE=3
	DHDCFLAGS += -DWL_SCB_TIMEOUT=10
	DHDCFLAGS += -DEXPLICIT_DISCIF_CLEANUP
	DHDCFLAGS += -DDHD_USE_SCAN_WAKELOCK
	DHDCFLAGS += -DSPECIFIC_MAC_GEN_SCHEME
	DHDCFLAGS += -DWL_IFACE_MGMT
	DHDCFLAGS += -DSUPPORT_RSSI_SUM_REPORT
	DHDCFLAGS += -DWLFBT -DWL_GCMP_SUPPORT -DWL_OWE -DWL_SAE_FT
	DHDCFLAGS += -DROAM_CHANNEL_CACHE -DDHD_LOSSLESS_ROAMING
#	DHDCFLAGS += -DWL_CFGVENDOR_SEND_HANG_EVENT
	DHDCFLAGS += -DGTK_OFFLOAD_SUPPORT
#	DHDCFLAGS += -DWL_STATIC_IF #-DDHD_MAX_STATIC_IFS=2
	DHDCFLAGS += -DWL_CLIENT_SAE
	DHDCFLAGS += -DCONNECT_INFO_WAR -DWL_ROAM_WAR
	DHDCFLAGS += -DVNDR_IE_WAR
	DHDCFLAGS += -DRESTART_AP_WAR -DRXF0OVFL_REINIT_WAR
endif

#BCMDHD_SDIO
ifneq ($(CONFIG_BCMDHD_SDIO),)
BUS_TYPE := sdio
DHDCFLAGS += -DBCMSDIO -DMMC_SDIO_ABORT -DUSE_SDIOFIFO_IOVAR -DBCMLXSDMMC \
	-DSDTEST -DBDC -DDHD_USE_IDLECOUNT -DCUSTOM_SDIO_F2_BLKSIZE=256       \
	-DBCMSDIOH_TXGLOM -DBCMSDIOH_TXGLOM_EXT -DBCMSDIOH_STATIC_COPY_BUF    \
	-DRXFRAME_THREAD -DDHDENABLE_TAILPAD -DSUPPORT_P2P_GO_PS              \
	-DBCMSDIO_RXLIM_POST -DBCMSDIO_TXSEQ_SYNC -DCONSOLE_DPC               \
	-DBCMSDIO_INTSTATUS_WAR
DHDCFLAGS += -DMMC_HW_RESET -DMMC_SW_RESET #-DBUS_POWER_RESTORE
ifeq ($(CONFIG_BCMDHD_OOB),y)
	DHDCFLAGS += -DOOB_INTR_ONLY -DCUSTOMER_OOB -DHW_OOB
ifeq ($(CONFIG_BCMDHD_DISABLE_WOWLAN),y)
	DHDCFLAGS += -DDISABLE_WOWLAN
endif
else
	DHDCFLAGS += -DSDIO_ISR_THREAD
endif
DHDOFILES += bcmsdh.o bcmsdh_linux.o bcmsdh_sdmmc.o bcmsdh_sdmmc_linux.o  \
	dhd_sdio.o dhd_cdc.o dhd_wlfc.o
endif

#BCMDHD_PCIE
ifneq ($(CONFIG_BCMDHD_PCIE),)
BUS_TYPE := pcie
	DHDCFLAGS += -DPCIE_FULL_DONGLE -DBCMPCIE -DCUSTOM_DPC_PRIO_SETTING=-1
	DHDCFLAGS += -DDONGLE_ENABLE_ISOLATION
	DHDCFLAGS += -DDHD_LB -DDHD_LB_RXP -DDHD_LB_STATS -DDHD_LB_TXP
	DHDCFLAGS += -DDHD_LB_PRIMARY_CPUS=0xF0 -DDHD_LB_SECONDARY_CPUS=0x0E
	DHDCFLAGS += -DDHD_PKTID_AUDIT_ENABLED
	DHDCFLAGS += -DEAPOL_PKT_PRIO -DENABLE_DHD_GRO
	DHDCFLAGS += -DDHD_SKIP_DONGLE_RESET_IN_ATTACH
	DHDCFLAGS += -DDHD_DONGLE_TRAP_IN_DETACH
	DHDCFLAGS += -DFORCE_DONGLE_RESET_IN_DEVRESET_ON
	DHDCFLAGS += -DDHD_USE_COHERENT_MEM_FOR_RING
	DHDCFLAGS += -DCHECK_TRAP_ROT
	DHDCFLAGS += -DINSMOD_FW_LOAD
	DHDCFLAGS += -DCONFIG_HAS_WAKELOCK #-DDHD_DEBUG_WAKE_LOCK
	DHDCFLAGS += -DDHD_PACKET_TIMEOUT_MS=50 -DMAX_TX_TIMEOUT=50
ifeq ($(CONFIG_BCMDHD),y)
	DHDCFLAGS += -DWAKEUP_KSOFTIRQD_POST_NAPI_SCHEDULE
endif
ifeq ($(CONFIG_BCMDHD_OOB),y)
	DHDCFLAGS += -DCUSTOMER_OOB -DBCMPCIE_OOB_HOST_WAKE -DHW_OOB
endif
ifneq ($(CONFIG_PCI_MSI),)
	DHDCFLAGS += -DDHD_MSI_SUPPORT
endif
DHDOFILES += dhd_pcie.o dhd_pcie_linux.o pcie_core.o dhd_flowring.o       \
	dhd_msgbuf.o dhd_linux_lb.o
endif

#BCMDHD_USB
ifneq ($(CONFIG_BCMDHD_USB),)
BUS_TYPE := usb
DHDCFLAGS += -DUSBOS_TX_THREAD -DBCMDBUS -DBCMTRXV2 -DDBUS_USB_LOOPBACK   \
	-DBDC
DHDCFLAGS += -DINSMOD_FW_LOAD
DHDCFLAGS += -DBCM_REQUEST_FW
DHDCFLAGS += -DSHOW_LOGTRACE
DHDCFLAGS += -DWL_EXT_WOWL
ifneq ($(CONFIG_BCMDHD_REQUEST_FW),y)
	DHDCFLAGS += -DEXTERNAL_FW_PATH
endif
ifneq ($(CONFIG_BCMDHD_CUSB),)
	DHDCFLAGS += -DBCMUSBDEV_COMPOSITE
	CONFIG_BCMDHD_NO_POWER_OFF := y
endif
DHDOFILES += dbus.o dbus_usb.o dbus_usb_linux.o dhd_cdc.o dhd_wlfc.o
endif

ifeq ($(CONFIG_BCMDHD_NO_POWER_OFF),y)
	DHDCFLAGS += -DENABLE_INSMOD_NO_FW_LOAD
	DHDCFLAGS += -DENABLE_INSMOD_NO_POWER_OFF -DNO_POWER_OFF_AFTER_OPEN
endif

ifeq ($(CONFIG_BCMDHD_MULTIPLE_DRIVER),y)
	DHDCFLAGS += -DBCMDHD_MDRIVER
ifneq ($(CONFIG_BCMDHD_ADAPTER_INDEX),)
	CONFIG_BCMDHD_STATIC_BUF_IN_DHD := y
	MODULE_NAME := dhd$(BUS_TYPE)_$(CONFIG_BCMDHD_ADAPTER_INDEX)
	DHDCFLAGS += -DADAPTER_IDX=$(CONFIG_BCMDHD_ADAPTER_INDEX)
	DHDCFLAGS += -DBUS_TYPE=\"-$(BUS_TYPE)-$(CONFIG_BCMDHD_ADAPTER_INDEX)\"
	DHDCFLAGS += -DDHD_LOG_PREFIX=\"[dhd-$(BUS_TYPE)-$(CONFIG_BCMDHD_ADAPTER_INDEX)]\"
else
	MODULE_NAME := dhd$(BUS_TYPE)
	DHDCFLAGS += -DBUS_TYPE=\"-$(BUS_TYPE)\"
	DHDCFLAGS += -DDHD_LOG_PREFIX=\"[dhd-$(BUS_TYPE)]\"
endif
else
	DHDCFLAGS += -DBUS_TYPE=\"\"
endif

ifeq ($(CONFIG_BCMDHD_TIMESTAMP),y)
	DHDCFLAGS += -DKERNEL_TIMESTAMP
	DHDCFLAGS += -DSYSTEM_TIMESTAMP
endif

#PROPTXSTATUS
ifeq ($(CONFIG_BCMDHD_PROPTXSTATUS),y)
ifneq ($(CONFIG_BCMDHD_USB),)
	DHDCFLAGS += -DPROP_TXSTATUS
	DHDCFLAGS += -DLIMIT_BORROW -DBULK_DEQUEUE
endif
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DPROP_TXSTATUS -DPROPTX_MAXCOUNT
	DHDCFLAGS += -DLIMIT_BORROW -DBULK_DEQUEUE
endif
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DPROP_TXSTATUS_VSDB
endif
endif

ifeq ($(CONFIG_64BIT),y)
    DHDCFLAGS := $(filter-out -DBCMDMA32,$(DHDCFLAGS))
    DHDCFLAGS += -DBCMDMA64OSL
endif

# For Android VTS
ifneq ($(CONFIG_BCMDHD_ANDROID_VERSION),)
	DHDCFLAGS += -DANDROID_VERSION=$(CONFIG_BCMDHD_ANDROID_VERSION)
	DHDCFLAGS += -DDHD_NOTIFY_MAC_CHANGED
	DHDCFLAGS += -DANDROID_BKPORT
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DPNO_SUPPORT
	DHDCFLAGS += -DGSCAN_SUPPORT -DRTT_SUPPORT -DLINKSTAT_SUPPORT
	DHDCFLAGS += -DCUSTOM_COUNTRY_CODE -DDHD_GET_VALID_CHANNELS
	DHDCFLAGS += -DDEBUGABILITY -DDBG_PKT_MON
	DHDCFLAGS += -DDHD_LOG_DUMP -DDHD_FW_COREDUMP
	DHDCFLAGS += -DAPF -DNDO_CONFIG_SUPPORT -DRSSI_MONITOR_SUPPORT
	DHDCFLAGS += -DDHD_WAKE_STATUS
	DHDCFLAGS += -DWL_SOFTAP_ACS
	DHDOFILES += dhd_rtt.o
	DHDOFILES += dhd_log_dump.o
endif
else
	DHDCFLAGS += -DANDROID_VERSION=0
endif

# For Debug
ifeq ($(CONFIG_BCMDHD_DEBUG),y)
	DHDCFLAGS += -DDHD_ARP_DUMP -DDHD_DHCP_DUMP -DDHD_ICMP_DUMP
	DHDCFLAGS += -DDHD_DNS_DUMP -DDHD_TRX_DUMP
	DHDCFLAGS += -DTPUT_MONITOR
#	DHDCFLAGS += -DSCAN_SUPPRESS -DBSSCACHE
	DHDCFLAGS += -DCHECK_DOWNLOAD_FW
	DHDCFLAGS += -DPKT_STATICS
	DHDCFLAGS += -DKSO_DEBUG
#	DHDCFLAGS += -DDHD_PKTDUMP_TOFW
#	DHDCFLAGS += -DDHD_DUMP_FILE_WRITE_FROM_KERNEL
endif

# For Debug2
ifeq ($(CONFIG_BCMDHD_DEBUG2),y)
	DHDCFLAGS += -DDEBUGFS_CFG80211
	DHDCFLAGS += -DSHOW_LOGTRACE -DDHD_LOG_DUMP -DDHD_FW_COREDUMP
	DHDCFLAGS += -DBCMASSERT_LOG -DSI_ERROR_ENFORCE
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DEWP_EDL
	DHDCFLAGS += -DDNGL_EVENT_SUPPORT
	DHDCFLAGS += -DDHD_SSSR_DUMP
	DHDCFLAGS += -DDHD_MEM_STATS
	DHDCFLAGS += -DDHD_FLOW_RING_STATUS_TRACE
	DHDCFLAGS += -DDNGL_AXI_ERROR_LOGGING
endif
	DHDOFILES += dhd_log_dump.o
endif

# MESH support for kernel 3.10 later
ifeq ($(CONFIG_WL_MESH),y)
	DHDCFLAGS += -DWLMESH
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DWLMESH_CFG80211
endif
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DBCM_HOST_BUF -DDMA_HOST_BUFFER_LEN=0x80000
endif
	DHDCFLAGS += -DDHD_UPDATE_INTF_MAC
	DHDCFLAGS :=$(filter-out -DDHD_FW_COREDUMP,$(DHDCFLAGS))
	DHDCFLAGS :=$(filter-out -DWL_STATIC_IF,$(DHDCFLAGS))
endif

# EasyMesh
ifeq ($(CONFIG_BCMDHD_EASYMESH),y)
	DHDCFLAGS :=$(filter-out -DDHD_FW_COREDUMP,$(DHDCFLAGS))
	DHDCFLAGS :=$(filter-out -DDHD_LOG_DUMP,$(DHDCFLAGS))
	DHDCFLAGS += -DWLEASYMESH
	CONFIG_BCMDHD_DWDS := y
endif

# DWDS
ifeq ($(CONFIG_BCMDHD_DWDS),y)
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DWLDWDS -DFOURADDR_AUTO_BRG
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DRXF_DEQUEUE_ON_BUSY
endif
	DHDCFLAGS += -DWL_STATIC_IF
endif
endif

# CSI_SUPPORT
ifeq ($(CONFIG_CSI_SUPPORT),y)
	DHDCFLAGS += -DCSI_SUPPORT
	DHDOFILES += dhd_csi.o
endif

# For CONNECTION_IMPROVE
ifeq ($(CONFIG_BCMDHD_RECONNECT),y)
	DHDCFLAGS += -DEAPOL_RESEND -DEAPOL_RESEND_M4
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DWL_EXT_RECONNECT -DWL_REASSOC_BCAST
	DHDCFLAGS += -DWL_EXT_DISCONNECT_RECONNECT
endif
endif

# For TPUT_IMPROVE
ifeq ($(CONFIG_BCMDHD_TPUT),y)
	DHDCFLAGS += -DDHD_TPUT_PATCH
	DHDCFLAGS += -DTCPACK_INFO_MAXNUM=40 -DTCPDATA_INFO_MAXNUM=40
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DDYNAMIC_MAX_HDR_READ
	DHDCFLAGS :=$(filter-out -DSDTEST,$(DHDCFLAGS))
endif
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DDHD_LB_TXP_DEFAULT_ENAB
	DHDCFLAGS += -DSET_RPS_CPUS -DSET_XPS_CPUS
	DHDCFLAGS += -DDHD_LB_PRIMARY_CPUS=0xF0 -DDHD_LB_SECONDARY_CPUS=0x0E
endif
endif

# For Zero configure
ifeq ($(CONFIG_BCMDHD_ZEROCONFIG),y)
	DHDCFLAGS += -DWL_EXT_GENL -DSENDPROB
	DHDOFILES += wl_ext_genl.o
endif

# For WAPI
ifeq ($(CONFIG_BCMDHD_WAPI),y)
	DHDCFLAGS += -DBCMWAPI_WPI -DBCMWAPI_WAI
ifeq ($(CONFIG_BCMDHD_ANDROID_VERSION),11)
	DHDCFLAGS += -DCFG80211_WAPI_BKPORT
endif
endif

# For scan random mac
ifneq ($(CONFIG_BCMDHD_RANDOM_MAC),)
ifneq ($(CONFIG_CFG80211),)
	DHDCFLAGS += -DSUPPORT_RANDOM_MAC_SCAN -DWL_USE_RANDOMIZED_SCAN
endif
endif

# For NAN
ifneq ($(CONFIG_BCMDHD_NAN),)
	DHDCFLAGS += -DWL_NAN -DWL_NAN_DISC_CACHE -DWL_NANP2P -DWL_NAN_ENABLE_MERGE
	DHDOFILES += wl_cfgnan.o bcmbloom.o
endif

# For Module auto-selection
ifeq ($(CONFIG_BCMDHD_AUTO_SELECT),y)
	DHDCFLAGS += -DUPDATE_MODULE_NAME
ifeq ($(CONFIG_BCMDHD_REQUEST_FW),y)
#	DHDCFLAGS += -DFW_AMPAK_PATH="\"ampak\""
#	DHDCFLAGS += -DMODULE_PATH
endif
ifneq ($(CONFIG_BCMDHD_SDIO),)
	DHDCFLAGS += -DGET_OTP_MODULE_NAME -DCOMPAT_OLD_MODULE
endif
endif

ifeq ($(CONFIG_BCMDHD),y)
	DHDCFLAGS += -DUSE_LATE_INITCALL_SYNC
	DHDCFLAGS += -DBCM_USE_PLATFORM_STRLCPY
endif
ifeq ($(CONFIG_BCMDHD),m)
	DHDCFLAGS += -DBCMDHD_MODULAR
	DHDCFLAGS += -DBOARD_MODULAR_INIT
endif

ifeq ($(CONFIG_MACH_PLATFORM),y)
	DHDOFILES += dhd_gpio.o
ifeq ($(CONFIG_BCMDHD_DTS),y)
	DHDCFLAGS += -DBCMDHD_DTS
endif
	DHDCFLAGS += -DCUSTOMER_HW -DDHD_OF_SUPPORT
endif

ifeq ($(CONFIG_BCMDHD_REQUEST_FW),y)
	DHDCFLAGS += -DDHD_LINUX_STD_FW_API
	DHDCFLAGS += -DDHD_REQUEST_FW_PATH
	DHDCFLAGS += -DDHD_FW_NAME="\"fw_bcmdhd.bin\""
	DHDCFLAGS += -DDHD_NVRAM_NAME="\"nvram.txt\""
	DHDCFLAGS += -DDHD_CLM_NAME="\"clm_bcmdhd.blob\""
else
	DHDCFLAGS += -DDHD_SUPPORT_VFS_CALL
ifeq ($(CONFIG_BCMDHD_FW_PATH),)
	DHDCFLAGS += -DCONFIG_BCMDHD_FW_PATH="\"/vendor/etc/firmware/fw_bcmdhd.bin\""
	DHDCFLAGS += -DCONFIG_BCMDHD_NVRAM_PATH="\"/vendor/etc/firmware/nvram.txt\""
	DHDCFLAGS += -DCONFIG_BCMDHD_CLM_PATH="\"/vendor/etc/firmware/clm_bcmdhd.blob\""
endif
endif

ifeq ($(CONFIG_BCMDHD_FW_SIGNATURE),y)
	DHDCFLAGS += -DFW_SIGNATURE
	DHDCFLAGS += -DBL_HEAP_START_GAP_SIZE=0x1000 -DBL_HEAP_SIZE=0x10000
endif

ifeq ($(CONFIG_BCMDHD_AG),y)
	DHDCFLAGS += -DBAND_AG
endif

ifeq ($(CONFIG_DHD_USE_STATIC_BUF),y)
ifeq  ($(CONFIG_BCMDHD_STATIC_BUF_IN_DHD),y)
	DHDOFILES += dhd_static_buf.o
	DHDCFLAGS += -DDHD_STATIC_IN_DRIVER
else
	obj-m += dhd_static_buf.o
endif
	DHDCFLAGS += -DSTATIC_WL_PRIV_STRUCT -DENHANCED_STATIC_BUF
	DHDCFLAGS += -DCONFIG_DHD_USE_STATIC_BUF
ifneq ($(filter -DDHD_LOG_DUMP, $(DHDCFLAGS)),)
	DHDCFLAGS += -DDHD_USE_STATIC_MEMDUMP
endif
ifneq ($(filter -DDHD_FW_COREDUMP, $(DHDCFLAGS)),)
	DHDCFLAGS += -DDHD_USE_STATIC_MEMDUMP
endif
ifneq ($(CONFIG_BCMDHD_PCIE),)
	DHDCFLAGS += -DDHD_USE_STATIC_CTRLBUF
endif
endif

ARCH ?= arm64
BCMDHD_ROOT = $(src)
#$(warning "BCMDHD_ROOT=$(BCMDHD_ROOT)")
EXTRA_CFLAGS = $(DHDCFLAGS)
EXTRA_CFLAGS += -DDHD_COMPILED=\"$(BCMDHD_ROOT)\"
EXTRA_CFLAGS += -I$(BCMDHD_ROOT)/include/ -I$(BCMDHD_ROOT)/
ifeq ($(CONFIG_BCMDHD),m)
EXTRA_LDFLAGS += --strip-debug
endif

obj-$(CONFIG_BCMDHD) += $(MODULE_NAME).o
$(MODULE_NAME)-objs += $(DHDOFILES)
ccflags-y := $(EXTRA_CFLAGS)

all: bcmdhd_pcie bcmdhd_sdio bcmdhd_usb

bcmdhd_pcie:
	$(warning "building BCMDHD_PCIE..........")
	$(MAKE) -C $(LINUXDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules CONFIG_BCMDHD=m CONFIG_BCMDHD_PCIE=y

bcmdhd_sdio:
	$(warning "building BCMDHD_SDIO..........")
	$(MAKE) -C $(LINUXDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules CONFIG_BCMDHD=m CONFIG_BCMDHD_SDIO=y

bcmdhd_usb:
	$(warning "building BCMDHD_USB..........")
	$(MAKE) -C $(LINUXDIR) M=$(PWD) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules CONFIG_BCMDHD=m CONFIG_BCMDHD_USB=y

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) ARCH=$(ARCH) clean
	$(RM) Module.markers
	$(RM) modules.order
