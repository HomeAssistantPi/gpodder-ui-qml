
/**
 *
 * gPodder QML UI Reference Implementation
 * Copyright (c) 2013, Thomas Perl <m@thp.io>
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 */

import QtQuick 2.0

import 'common/constants.js' as Constants
import 'icons/icons.js' as Icons

SlidePage {
    id: detailPage

    property int episode_id
    property string title
    property string link
    property bool ready: false

    hasMenuButton: detailPage.link != ''
    menuButtonIcon: Icons.link
    menuButtonLabel: 'Website'
    onMenuButtonClicked: Qt.openUrlExternally(detailPage.link)

    PBusyIndicator {
        anchors.centerIn: parent
        visible: !detailPage.ready
    }

    Component.onCompleted: {
        py.call('main.show_episode', [episode_id], function (episode) {
            descriptionLabel.text = episode.description;
            metadataLabel.text = episode.metadata;
            detailPage.link = episode.link;
            detailPage.ready = true;
        });
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: detailColumn.width
        contentHeight: detailColumn.height + detailColumn.spacing

        Column {
            id: detailColumn

            width: detailPage.width
            spacing: 10 * pgst.scalef

            Item { height: 20 * pgst.scalef; width: parent.width }

            Column {
                width: parent.width - 2 * 30 * pgst.scalef
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10 * pgst.scalef

                PLabel {
                    text: detailPage.title
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.pixelSize: 35 * pgst.scalef
                    color: Constants.colors.highlight
                }

                PLabel {
                    id: metadataLabel
                    width: parent.width
                    wrapMode: Text.WordWrap
                    font.pixelSize: 20 * pgst.scalef
                    color: Constants.colors.placeholder
                }

                PLabel {
                    id: descriptionLabel
                    width: parent.width
                    font.pixelSize: 30 * pgst.scalef
                    wrapMode: Text.WordWrap
                }
        }
        }
    }

    PScrollDecorator { flickable: flickable }
}

