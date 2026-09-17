import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

BarIndicator {
  id: root

  readonly property var idleService: bar?.shell?.serviceFor("azterisk.idle") || bar?.shell?.firstPartyServiceFor("omarchy.idle")

  property bool popupOpen: false

  function close() {
    root.popupOpen = false
  }

  active: idleService ? idleService.stayAwake : false
  activeText: "󰅶"
  inactiveText: "󰅶"
  activeTooltipText: idleService && idleService.stayAwakeAllowsScreensaver
    ? "Stay Awake: Active (Screensaver Enabled, Lock Inactive)\nLeft-click: Toggle off | Right-click: Settings"
    : "Stay Awake: Active (Screensaver & Lock Inactive)\nLeft-click: Toggle off | Right-click: Settings"
  inactiveTooltipText: "Stay Awake: Inactive (Normal Idle & Lock)\nLeft-click: Toggle on | Right-click: Settings"

  function toggle() {
    if (root.idleService) root.idleService.setIdleEnabled(root.active)
  }

  onPressed: function(button) {
    if (button === Qt.RightButton) {
      root.popupOpen = !root.popupOpen
    } else {
      root.toggle()
    }
  }

  PopupCard {
    id: settingsPopup
    anchorItem: root
    bar: root.bar
    owner: root
    open: root.popupOpen
    margin: Style.space(12)
    padding: Style.space(24)
    contentWidth: settingsPopup.fittedContentWidth(Style.space(380))
    contentHeight: settingsPopup.fittedContentHeight(contentWrapper.implicitHeight)

    Item {
      id: contentWrapper
      anchors.fill: parent
      anchors.topMargin: Style.space(8)
      anchors.bottomMargin: Style.space(8)
      anchors.leftMargin: Style.space(8)
      anchors.rightMargin: Style.space(8)
      implicitHeight: contentColumn.implicitHeight + Style.space(16)

      Column {
        id: contentColumn
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(16)

        // Header Row
        Row {
          width: parent.width
          spacing: Style.space(10)

          Text {
            text: "󰅶"
            color: root.active ? (root.bar ? root.bar.urgent : Color.urgent) : Color.foreground
            font.family: Style.font.family
            font.pixelSize: Style.font.title
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            text: "Stay Awake & Idle"
            color: Color.foreground
            font.family: Style.font.family
            font.pixelSize: Style.font.subtitle
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - Style.space(110)
            elide: Text.ElideRight
          }

          BorderSurface {
            anchors.verticalCenter: parent.verticalCenter
            height: Style.space(26)
            width: Style.space(68)
            radius: Style.cornerRadius
            color: root.active ? Qt.rgba(Color.accent.r, Color.accent.g, Color.accent.b, 0.2) : Qt.rgba(Color.foreground.r, Color.foreground.g, Color.foreground.b, 0.1)
            borderSpec: Border.controlSpec("normal", Color.foreground, Color.accent)

            Text {
              anchors.centerIn: parent
              text: root.active ? "ACTIVE" : "OFF"
              color: root.active ? Color.accent : Qt.darker(Color.foreground, 1.4)
              font.family: Style.font.family
              font.pixelSize: Style.font.caption
              font.bold: true
            }
          }
        }

        PanelSeparator { strength: 0.2 }

        // Master Toggle
        Toggle {
          width: parent.width
          label: "Stay Awake Mode"
          description: root.active ? "System lock is currently suppressed" : "Normal idle and lock timeouts active"
          checked: root.active
          onClicked: root.toggle()
        }

        // Stay Awake Behavior
        Column {
          width: parent.width
          spacing: Style.space(8)

          PanelSectionHeader {
            text: "STAY AWAKE BEHAVIOR"
            topPadding: Style.space(4)
          }

          Row {
            width: parent.width
            spacing: Style.space(10)

            Button {
              width: Math.floor((parent.width - Style.space(10)) / 2)
              text: "Screensaver"
              iconText: "󱄄"
              tooltipText: "Show screensaver on idle, but never lock PC"
              bordered: true
              selected: root.idleService ? root.idleService.stayAwakeMode === "screensaver-only" : true
              onClicked: if (root.idleService) root.idleService.setStayAwakeMode("screensaver-only")
            }

            Button {
              width: Math.floor((parent.width - Style.space(10)) / 2)
              text: "Inhibit All"
              iconText: "󰅶"
              tooltipText: "Keep screen completely awake (no screensaver, no lock)"
              bordered: true
              selected: root.idleService ? root.idleService.stayAwakeMode === "full" : false
              onClicked: if (root.idleService) root.idleService.setStayAwakeMode("full")
            }
          }
        }

        // Screensaver Timeout
        Column {
          width: parent.width
          spacing: Style.space(8)

          PanelSectionHeader {
            text: "SCREENSAVER TIMEOUT"
            topPadding: Style.space(4)
          }

          Row {
            width: parent.width
            spacing: Style.space(6)

            readonly property int btnWidth: Math.floor((parent.width - Style.space(24)) / 5)

            Repeater {
              model: [
                { value: 60, label: "1m", tooltip: "Screensaver after 1 minute" },
                { value: 150, label: "2.5m", tooltip: "Screensaver after 2.5 minutes" },
                { value: 300, label: "5m", tooltip: "Screensaver after 5 minutes" },
                { value: 600, label: "10m", tooltip: "Screensaver after 10 minutes" },
                { value: 0, label: "Off", tooltip: "Disable screensaver" }
              ]

              delegate: Button {
                required property var modelData
                width: parent.btnWidth
                text: modelData.label
                tooltipText: modelData.tooltip
                bordered: true
                selected: Boolean(root.idleService && (modelData.value === 0 ? !root.idleService.screensaverEnabled : (root.idleService.screensaverEnabled && root.idleService.screensaverTimeoutSeconds === modelData.value)))
                onClicked: if (root.idleService) root.idleService.setScreensaverTimeout(modelData.value)
              }
            }
          }
        }

        // System Lock Timeout
        Column {
          width: parent.width
          spacing: Style.space(8)

          PanelSectionHeader {
            text: "NORMAL LOCK TIMEOUT"
            topPadding: Style.space(4)
          }

          Row {
            width: parent.width
            spacing: Style.space(6)

            readonly property int btnWidth: Math.floor((parent.width - Style.space(24)) / 5)

            Repeater {
              model: [
                { value: 120, label: "2m", tooltip: "Lock after 2 minutes idle" },
                { value: 300, label: "5m", tooltip: "Lock after 5 minutes idle" },
                { value: 600, label: "10m", tooltip: "Lock after 10 minutes idle" },
                { value: 900, label: "15m", tooltip: "Lock after 15 minutes idle" },
                { value: 0, label: "Never", tooltip: "Disable idle locking" }
              ]

              delegate: Button {
                required property var modelData
                width: parent.btnWidth
                text: modelData.label
                tooltipText: modelData.tooltip
                bordered: true
                selected: Boolean(root.idleService && (modelData.value === 0 ? !root.idleService.lockEnabled : (root.idleService.lockEnabled && root.idleService.lockTimeoutSeconds === modelData.value)))
                onClicked: if (root.idleService) root.idleService.setLockTimeout(modelData.value)
              }
            }
          }
        }

        PanelSeparator { strength: 0.2 }

        // Quick Actions
        Row {
          width: parent.width
          spacing: Style.space(10)

          Button {
            width: Math.floor((parent.width - Style.space(10)) / 2)
            text: "Screensaver"
            iconText: "󱄄"
            tooltipText: "Launch screensaver now"
            bordered: true
            onClicked: {
              root.popupOpen = false
              if (root.bar) root.bar.run("omarchy-launch-screensaver force")
            }
          }

          Button {
            width: Math.floor((parent.width - Style.space(10)) / 2)
            text: "Lock Screen"
            iconText: "󰌾"
            tooltipText: "Lock PC immediately"
            bordered: true
            onClicked: {
              root.popupOpen = false
              if (root.bar) root.bar.run("omarchy-system-lock")
            }
          }
        }
      }
    }
  }
}
