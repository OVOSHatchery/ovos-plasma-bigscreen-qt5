/*
    SPDX-FileCopyrightText: 2019 Aditya Mehra <aix.m@outlook.com>
    SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.14
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14 as Controls
import QtQuick.Window 2.14
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0
import org.kde.kirigami 2.12 as Kirigami
import org.kde.kitemmodels 1.0 as KItemModels

import "delegates" as Delegates
import org.kde.mycroft.bigscreen 1.0 as BigScreen
import org.kde.private.biglauncher 1.0 
import org.kde.plasma.private.kicker 0.1 as Kicker

FocusScope {
    property bool mycroftIntegration: plasmoid.nativeInterface.bigLauncherDbusAdapterInterface.mycroftIntegrationActive() ? 1 : 0

    Connections {
        target: plasmoid.nativeInterface.bigLauncherDbusAdapterInterface

    }

    anchors {
        fill: parent
        leftMargin: Kirigami.Units.largeSpacing * 4
        topMargin: Kirigami.Units.largeSpacing * 3
    }

    ColumnLayout {
        id: launcherHomeColumn
        anchors {
            left: parent.left
            right: parent.right
        }
        property Item currentSection
        y: currentSection ? -currentSection.y + parent.height/2 - currentSection.height/2 : parent.height/2

        Behavior on y {
            YAnimator {
                duration: Kirigami.Units.longDuration * 2
                easing.type: Easing.InOutQuad
            }
        }
        //height: parent.height
        spacing: Kirigami.Units.largeSpacing*3

        BigScreen.TileRepeater {
            id: voiceAppsView
            title: i18n("Voice Apps")
            compactMode: plasmoid.configuration.expandingTiles
            model: KItemModels.KSortFilterProxyModel {
                sourceModel: plasmoid.nativeInterface.applicationListModel
                filterRole: "ApplicationCategoriesRole"
                filterRowCallback: function(source_row, source_parent) {
                    return sourceModel.data(sourceModel.index(source_row, 0, source_parent), ApplicationListModel.ApplicationCategoriesRole).indexOf("VoiceApp") !== -1;
                }
            }

            visible: count > 0
            currentIndex: 0
            focus: false
            onActiveFocusChanged: if (activeFocus) launcherHomeColumn.currentSection = voiceAppsView
            delegate: Delegates.VoiceAppDelegate {
                property var modelData: typeof model !== "undefined" ? model : null
                
            }

            navigationUp: shutdownIndicator
            navigationDown: mediaAppsView.visible ? mediaAppsView : networkAppsView.visible ? networkAppsView : gamesView.visible ? gamesView : graphicsView.visible ? graphicsView : settingsView
        }

        BigScreen.TileRepeater {
            id: mediaAppsView
            title: i18n("Multimedia")
            compactMode: plasmoid.configuration.expandingTiles
            model: KItemModels.KSortFilterProxyModel {
                sourceModel: plasmoid.nativeInterface.applicationListModel
                filterRole: "ApplicationCategoriesRole"
                filterRowCallback: function(source_row, source_parent) {
                    return sourceModel.data(sourceModel.index(source_row, 0, source_parent), ApplicationListModel.ApplicationCategoriesRole).indexOf("AudioVideo") !== -1;
                }
            }

            visible: count > 0
            currentIndex: 0
            focus: false
            onActiveFocusChanged: if (activeFocus) launcherHomeColumn.currentSection = mediaAppsView
            delegate: Delegates.VoiceAppDelegate {
                property var modelData: typeof model !== "undefined" ? model : null

            }

            navigationUp: voiceAppsView.visible ? voiceAppsView : shutdownIndicator
            navigationDown: networkAppsView.visible ? networkAppsView: gamesView.visible ? gamesView : graphicsView.visible ? graphicsView : settingsView
        }

        BigScreen.TileRepeater {
            id: networkAppsView
            title: i18n("Network")
            compactMode: plasmoid.configuration.expandingTiles
            model: KItemModels.KSortFilterProxyModel {
                sourceModel: plasmoid.nativeInterface.applicationListModel
                filterRole: "ApplicationCategoriesRole"
                filterRowCallback: function(source_row, source_parent) {
                    return sourceModel.data(sourceModel.index(source_row, 0, source_parent), ApplicationListModel.ApplicationCategoriesRole).indexOf("Network") !== -1;
                }
            }

            visible: count > 0
            currentIndex: 0
            focus: false
            onActiveFocusChanged: if (activeFocus) launcherHomeColumn.currentSection = networkAppsView
            delegate: Delegates.VoiceAppDelegate {
                property var modelData: typeof model !== "undefined" ? model : null

            }

            navigationUp: mediaAppsView.visible ? mediaAppsView : voiceAppsView.visible ? voiceAppsView : shutdownIndicator
            navigationDown: gamesView.visible ? gamesView : graphicsView.visible ? graphicsView : settingsView
        }

        BigScreen.TileRepeater {
            id: gamesView
            title: i18n("Games")
            compactMode: plasmoid.configuration.expandingTiles
            visible: count > 0
            enabled: count > 0
            model: KItemModels.KSortFilterProxyModel {
                sourceModel: plasmoid.nativeInterface.applicationListModel
                filterRole: "ApplicationCategoriesRole"
                filterRowCallback: function(source_row, source_parent) {
                    return sourceModel.data(sourceModel.index(source_row, 0, source_parent), ApplicationListModel.ApplicationCategoriesRole).indexOf("Game") !== -1;
                }
            }

            currentIndex: 0
            focus: false
            onActiveFocusChanged: if (activeFocus) launcherHomeColumn.currentSection = gamesView
            delegate: Delegates.AppDelegate {
                property var modelData: typeof model !== "undefined" ? model : null
            }
            
            navigationUp: networkAppsView.visible ? networkAppsView : mediaAppsView.visible ? mediaAppsView : voiceAppsView.visible ? voiceAppsView : shutdownIndicator
            navigationDown: graphicsView.visible ? graphicsView : settingsView
        }

        BigScreen.TileRepeater {
            id: graphicsView
            title: i18n("Graphics")
            compactMode: plasmoid.configuration.expandingTiles
            visible: count > 0
            enabled: count > 0
            model: KItemModels.KSortFilterProxyModel {
                sourceModel: plasmoid.nativeInterface.applicationListModel
                filterRole: "ApplicationCategoriesRole"
                filterRowCallback: function(source_row, source_parent) {
                    return sourceModel.data(sourceModel.index(source_row, 0, source_parent), ApplicationListModel.ApplicationCategoriesRole).indexOf("Graphics") !== -1;
                }
            }

            currentIndex: 0
            focus: false
            onActiveFocusChanged: if (activeFocus) launcherHomeColumn.currentSection = graphicsView
            delegate: Delegates.AppDelegate {
                property var modelData: typeof model !== "undefined" ? model : null
            }

            navigationUp: gamesView.visible ? gamesView : networkAppsView.visible ? networkAppsView : mediaAppsView.visible ? mediaAppsView : voiceAppsView.visible ? voiceAppsView : shutdownIndicator
            navigationDown: settingsView
        }

        SettingActions {
            id: settingActions
        }
        
        BigScreen.TileRepeater {
            id: settingsView
            title: i18n("Settings")
            model: plasmoid.nativeInterface.kcmsListModel
            compactMode: plasmoid.configuration.expandingTiles

            onActiveFocusChanged: if (activeFocus) launcherHomeColumn.currentSection = settingsView
            delegate: Delegates.SettingDelegate {
                property var modelData: typeof model !== "undefined" ? model : null
                visible: model.active
                enabled: model.active
            }
            
            navigationUp:  graphicsView.visible ? graphicsView : gamesView.visible ? gamesView : networkAppsView.visible ? networkAppsView : mediaAppsView.visible ? mediaAppsView : voiceAppsView.visible ? voiceAppsView : shutdownIndicator
            navigationDown: null
        }

        Component.onCompleted: {
            if (recentView.visible) {
                recentView.forceActiveFocus();
            } else if(voiceAppsView.visible) {
                voiceAppsView.forceActiveFocus();
            } else {
                appsView.forceActiveFocus();
            }
        }

        Connections {
            target: root
            onActivateAppView: {
                voiceAppsView.forceActiveFocus();
            }
        }
    }
}

