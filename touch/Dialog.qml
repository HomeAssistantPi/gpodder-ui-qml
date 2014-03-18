
/**
 *
 * gPodder QML UI Reference Implementation
 * Copyright (c) 2014, Thomas Perl <m@thp.io>
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

Rectangle {
    id: page
    z: 200

    color: Constants.colors.dialogBackground

    Component.onCompleted: pgst.dialogsVisible = pgst.dialogsVisible + 1;
    Component.onDestruction: pgst.dialogsVisible = pgst.dialogsVisible - 1;

    default property alias children: contents.children
    property bool isDialog: true
    property int contentHeight: -1
    property bool fullWidth: false

    function closePage() {
        stacking.startFadeOut();
    }

    onXChanged: pgst.update(page, x)

    width: parent.width
    height: parent.height

    DialogStacking { id: stacking }

    MouseArea {
        anchors.fill: parent
        onClicked: page.closePage();
    }

    Rectangle {
        id: contents
        property int border: parent.width * 0.1
        width: parent.fullWidth ? parent.width : (parent.width - 2 * border)
        property int maxHeight: parent.height - toolbar.height
        height: ((page.contentHeight > 0 && page.contentHeight < maxHeight) ? page.contentHeight : maxHeight) * parent.opacity
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
        color: Constants.colors.dialog
        clip: true
    }
}
