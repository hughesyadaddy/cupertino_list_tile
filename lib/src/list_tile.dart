// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart'
    show
        ListTileTheme,
        MaterialState,
        MaterialStateMouseCursor,
        MaterialStateProperty;
export 'package:flutter/material.dart' show ListTileTheme;

import 'list_tile_background.dart';

/// A single fixed-height row that typically contains some text as well as
/// a leading or trailing icon.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=l8dj0yPBvgQ}
///
/// A list tile contains one to three lines of text optionally flanked by icons or
/// other widgets, such as check boxes. The icons (or other widgets) for the
/// tile are defined with the [leading] and [trailing] parameters. The first
/// line of text is not optional and is specified with [title]. The value of
/// [subtitle], which _is_ optional, will occupy the space allocated for an
/// additional line of text, or two lines if [isThreeLine] is true. If [dense]
/// is true then the overall height of this tile and the size of the
/// [DefaultTextStyle]s that wrap the [title] and [subtitle] widget are reduced.
///
/// It is the responsibility of the caller to ensure that [title] does not wrap,
/// and to ensure that [subtitle] doesn't wrap (if [isThreeLine] is false) or
/// wraps to two lines (if it is true).
///
/// The heights of the [leading] and [trailing] widgets are constrained
/// according to the
/// [Material spec](https://material.io/design/components/lists.html).
/// An exception is made for one-line ListTiles for accessibility. Please
/// see the example below to see how to adhere to both Material spec and
/// accessibility requirements.
///
/// Note that [leading] and [trailing] widgets can expand as far as they wish
/// horizontally, so ensure that they are properly constrained.
///
/// List tiles are typically used in [ListView]s, or arranged in [Column]s in
/// [Drawer]s and [Card]s.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// {@tool snippet}
///
/// This example uses a [ListView] to demonstrate different configurations of
/// [CupertinoListTile]s in [Card]s.
///
/// ![Different variations of ListTile](https://flutter.github.io/assets-for-api-docs/assets/material/list_tile.png)
///
/// ```dart
/// ListView(
///   children: const <Widget>[
///     Card(child: ListTile(title: Text('One-line ListTile'))),
///     Card(
///       child: ListTile(
///         leading: FlutterLogo(),
///         title: Text('One-line with leading widget'),
///       ),
///     ),
///     Card(
///       child: ListTile(
///         title: Text('One-line with trailing widget'),
///         trailing: Icon(Icons.more_vert),
///       ),
///     ),
///     Card(
///       child: ListTile(
///         leading: FlutterLogo(),
///         title: Text('One-line with both widgets'),
///         trailing: Icon(Icons.more_vert),
///       ),
///     ),
///     Card(
///       child: ListTile(
///         title: Text('One-line dense ListTile'),
///         dense: true,
///       ),
///     ),
///     Card(
///       child: ListTile(
///         leading: FlutterLogo(size: 56.0),
///         title: Text('Two-line ListTile'),
///         subtitle: Text('Here is a second line'),
///         trailing: Icon(Icons.more_vert),
///       ),
///     ),
///     Card(
///       child: ListTile(
///         leading: FlutterLogo(size: 72.0),
///         title: Text('Three-line ListTile'),
///         subtitle: Text(
///           'A sufficiently long subtitle warrants three lines.'
///         ),
///         trailing: Icon(Icons.more_vert),
///         isThreeLine: true,
///       ),
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
/// {@tool snippet}
///
/// Tiles can be much more elaborate. Here is a tile which can be tapped, but
/// which is disabled when the `_act` variable is not 2. When the tile is
/// tapped, the whole row has an ink splash effect (see [InkWell]).
///
/// ```dart
/// int _act = 1;
/// // ...
/// ListTile(
///   leading: const Icon(Icons.flight_land),
///   title: const Text("Trix's airplane"),
///   subtitle: _act != 2 ? const Text('The airplane is only in Act II.') : null,
///   enabled: _act == 2,
///   onTap: () { /* react to the tile being tapped */ }
/// )
/// ```
/// {@end-tool}
///
/// To be accessible, tappable [leading] and [trailing] widgets have to
/// be at least 48x48 in size. However, to adhere to the Material spec,
/// [trailing] and [leading] widgets in one-line ListTiles should visually be
/// at most 32 ([dense]: true) or 40 ([dense]: false) in height, which may
/// conflict with the accessibility requirement.
///
/// For this reason, a one-line ListTile allows the height of [leading]
/// and [trailing] widgets to be constrained by the height of the ListTile.
/// This allows for the creation of tappable [leading] and [trailing] widgets
/// that are large enough, but it is up to the developer to ensure that
/// their widgets follow the Material spec.
///
/// {@tool snippet}
///
/// Here is an example of a one-line, non-[dense] ListTile with a
/// tappable leading widget that adheres to accessibility requirements and
/// the Material spec. To adjust the use case below for a one-line, [dense]
/// ListTile, adjust the vertical padding to 8.0.
///
/// ```dart
/// ListTile(
///   leading: GestureDetector(
///     behavior: HitTestBehavior.translucent,
///     onTap: () {},
///     child: Container(
///       width: 48,
///       height: 48,
///       padding: EdgeInsets.symmetric(vertical: 4.0),
///       alignment: Alignment.center,
///       child: CircleAvatar(),
///     ),
///   ),
///   title: Text('title'),
///   dense: false,
/// ),
/// ```
/// {@end-tool}
///
/// ## The ListTile layout isn't exactly what I want
///
/// If the way ListTile pads and positions its elements isn't quite what
/// you're looking for, it's easy to create custom list items with a
/// combination of other widgets, such as [Row]s and [Column]s.
///
/// {@tool dartpad --template=stateless_widget_scaffold}
///
/// Here is an example of a custom list item that resembles a Youtube related
/// video list item created with [Expanded] and [Container] widgets.
///
/// ![Custom list item a](https://flutter.github.io/assets-for-api-docs/assets/widgets/custom_list_item_a.png)
///
/// ```dart preamble
/// class CustomListItem extends StatelessWidget {
///   const CustomListItem({
///     this.thumbnail,
///     this.title,
///     this.user,
///     this.viewCount,
///   });
///
///   final Widget thumbnail;
///   final String title;
///   final String user;
///   final int viewCount;
///
///   @override
///   Widget build(BuildContext context) {
///     return Padding(
///       padding: const EdgeInsets.symmetric(vertical: 5.0),
///       child: Row(
///         crossAxisAlignment: CrossAxisAlignment.start,
///         children: <Widget>[
///           Expanded(
///             flex: 2,
///             child: thumbnail,
///           ),
///           Expanded(
///             flex: 3,
///             child: _VideoDescription(
///               title: title,
///               user: user,
///               viewCount: viewCount,
///             ),
///           ),
///           const Icon(
///             Icons.more_vert,
///             size: 16.0,
///           ),
///         ],
///       ),
///     );
///   }
/// }
///
/// class _VideoDescription extends StatelessWidget {
///   const _VideoDescription({
///     Key key,
///     this.title,
///     this.user,
///     this.viewCount,
///   }) : super(key: key);
///
///   final String title;
///   final String user;
///   final int viewCount;
///
///   @override
///   Widget build(BuildContext context) {
///     return Padding(
///       padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
///       child: Column(
///         crossAxisAlignment: CrossAxisAlignment.start,
///         children: <Widget>[
///           Text(
///             title,
///             style: const TextStyle(
///               fontWeight: FontWeight.w500,
///               fontSize: 14.0,
///             ),
///           ),
///           const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
///           Text(
///             user,
///             style: const TextStyle(fontSize: 10.0),
///           ),
///           const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
///           Text(
///             '$viewCount views',
///             style: const TextStyle(fontSize: 10.0),
///           ),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// ```dart
/// Widget build(BuildContext context) {
///   return ListView(
///     padding: const EdgeInsets.all(8.0),
///     itemExtent: 106.0,
///     children: <CustomListItem>[
///       CustomListItem(
///         user: 'Flutter',
///         viewCount: 999000,
///         thumbnail: Container(
///           decoration: const BoxDecoration(color: Colors.blue),
///         ),
///         title: 'The Flutter YouTube Channel',
///       ),
///       CustomListItem(
///         user: 'Dash',
///         viewCount: 884000,
///         thumbnail: Container(
///           decoration: const BoxDecoration(color: Colors.yellow),
///         ),
///         title: 'Announcing Flutter 1.0',
///       ),
///     ],
///   );
/// }
/// ```
/// {@end-tool}
///
/// {@tool dartpad --template=stateless_widget_scaffold}
///
/// Here is an example of an article list item with multiline titles and
/// subtitles. It utilizes [Row]s and [Column]s, as well as [Expanded] and
/// [AspectRatio] widgets to organize its layout.
///
/// ![Custom list item b](https://flutter.github.io/assets-for-api-docs/assets/widgets/custom_list_item_b.png)
///
/// ```dart preamble
/// class _ArticleDescription extends StatelessWidget {
///   _ArticleDescription({
///     Key key,
///     this.title,
///     this.subtitle,
///     this.author,
///     this.publishDate,
///     this.readDuration,
///   }) : super(key: key);
///
///   final String title;
///   final String subtitle;
///   final String author;
///   final String publishDate;
///   final String readDuration;
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: <Widget>[
///         Expanded(
///           flex: 1,
///           child: Column(
///             crossAxisAlignment: CrossAxisAlignment.start,
///             children: <Widget>[
///               Text(
///                 '$title',
///                 maxLines: 2,
///                 overflow: TextOverflow.ellipsis,
///                 style: const TextStyle(
///                   fontWeight: FontWeight.bold,
///                 ),
///               ),
///               const Padding(padding: EdgeInsets.only(bottom: 2.0)),
///               Text(
///                 '$subtitle',
///                 maxLines: 2,
///                 overflow: TextOverflow.ellipsis,
///                 style: const TextStyle(
///                   fontSize: 12.0,
///                   color: Colors.black54,
///                 ),
///               ),
///             ],
///           ),
///         ),
///         Expanded(
///           flex: 1,
///           child: Column(
///             crossAxisAlignment: CrossAxisAlignment.start,
///             mainAxisAlignment: MainAxisAlignment.end,
///             children: <Widget>[
///               Text(
///                 '$author',
///                 style: const TextStyle(
///                   fontSize: 12.0,
///                   color: Colors.black87,
///                 ),
///               ),
///               Text(
///                 '$publishDate - $readDuration',
///                 style: const TextStyle(
///                   fontSize: 12.0,
///                   color: Colors.black54,
///                 ),
///               ),
///             ],
///           ),
///         ),
///       ],
///     );
///   }
/// }
///
/// class CustomListItemTwo extends StatelessWidget {
///   CustomListItemTwo({
///     Key key,
///     this.thumbnail,
///     this.title,
///     this.subtitle,
///     this.author,
///     this.publishDate,
///     this.readDuration,
///   }) : super(key: key);
///
///   final Widget thumbnail;
///   final String title;
///   final String subtitle;
///   final String author;
///   final String publishDate;
///   final String readDuration;
///
///   @override
///   Widget build(BuildContext context) {
///     return Padding(
///       padding: const EdgeInsets.symmetric(vertical: 10.0),
///       child: SizedBox(
///         height: 100,
///         child: Row(
///           crossAxisAlignment: CrossAxisAlignment.start,
///           children: <Widget>[
///             AspectRatio(
///               aspectRatio: 1.0,
///               child: thumbnail,
///             ),
///             Expanded(
///               child: Padding(
///                 padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
///                 child: _ArticleDescription(
///                   title: title,
///                   subtitle: subtitle,
///                   author: author,
///                   publishDate: publishDate,
///                   readDuration: readDuration,
///                 ),
///               ),
///             )
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// ```dart
/// Widget build(BuildContext context) {
///   return ListView(
///     padding: const EdgeInsets.all(10.0),
///     children: <Widget>[
///       CustomListItemTwo(
///         thumbnail: Container(
///           decoration: const BoxDecoration(color: Colors.pink),
///         ),
///         title: 'Flutter 1.0 Launch',
///         subtitle:
///           'Flutter continues to improve and expand its horizons.'
///           'This text should max out at two lines and clip',
///         author: 'Dash',
///         publishDate: 'Dec 28',
///         readDuration: '5 mins',
///       ),
///       CustomListItemTwo(
///         thumbnail: Container(
///           decoration: const BoxDecoration(color: Colors.blue),
///         ),
///         title: 'Flutter 1.2 Release - Continual updates to the framework',
///         subtitle: 'Flutter once again improves and makes updates.',
///         author: 'Flutter',
///         publishDate: 'Feb 26',
///         readDuration: '12 mins',
///       ),
///     ],
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ListTileTheme], which defines visual properties for [CupertinoListTile]s.
///  * [ListView], which can display an arbitrary number of [CupertinoListTile]s
///    in a scrolling list.
///  * [CircleAvatar], which shows an icon representing a person and is often
///    used as the [leading] element of a ListTile.
///  * [Card], which can be used with [Column] to show a few [CupertinoListTile]s.
///  * [Divider], which can be used to separate [CupertinoListTile]s.
///  * [CupertinoListTile.divideTiles], a utility for inserting [Divider]s in between [CupertinoListTile]s.
///  * [CheckboxListTile], [RadioListTile], and [SwitchListTile], widgets
///    that combine [ListTile] with other controls.
///  * <https://material.io/design/components/lists.html>
class CupertinoListTile extends StatelessWidget {
  /// Creates a list tile.
  ///
  /// If [isThreeLine] is true, then [subtitle] must not be null.
  ///
  /// Requires one of its ancestors to be a [Material] widget.
  const CupertinoListTile({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.selected = false,
    this.pressColor,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
  })  : assert(isThreeLine != null),
        assert(enabled != null),
        assert(selected != null),
        assert(autofocus != null),
        assert(!isThreeLine || subtitle != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  ///
  /// If [isThreeLine] is false, this should not wrap.
  ///
  /// If [isThreeLine] is true, this should be configured to take a maximum of
  /// two lines.
  final Widget subtitle;

  /// A widget to display after the title.
  ///
  /// Typically an [Icon] widget.
  ///
  /// To show right-aligned metadata (assuming left-to-right reading order;
  /// left-aligned for right-to-left reading order), consider using a [Row] with
  /// [MainAxisAlign.baseline] alignment whose first item is [Expanded] and
  /// whose second child is the metadata text, instead of using the [trailing]
  /// property.
  final Widget trailing;

  /// Whether this list tile is intended to display three lines of text.
  ///
  /// If true, then [subtitle] must be non-null (since it is expected to give
  /// the second and third lines of text).
  ///
  /// If false, the list tile is treated as having one line if the subtitle is
  /// null and treated as having two lines if the subtitle is non-null.
  final bool isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  ///
  /// If this property is null then its value is based on [ListTileTheme.dense].
  ///
  /// Dense list tiles default to a smaller height.
  final bool dense;

  /// The tile's internal padding.
  ///
  /// Insets a [CupertinoListTile]'s contents: its [leading], [title], [subtitle],
  /// and [trailing] widgets.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  /// Whether this list tile is interactive.
  ///
  /// If false, this list tile is styled with the disabled color from the
  /// current [Theme] and the [onTap] and [onLongPress] callbacks are
  /// inoperative.
  final bool enabled;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback onTap;

  /// Called when the user long-presses on this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureLongPressCallback onLongPress;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.disabled].
  ///
  /// If this property is null, [MaterialStateMouseCursor.clickable] will be used.
  final MouseCursor mouseCursor;

  /// If this tile is also [enabled] then icons and text are rendered with the same color.
  ///
  /// By default the selected color is the theme's primary color. The selected color
  /// can be overridden with a [ListTileTheme].
  final bool selected;

  /// The color for the tile's background when it is pressed.
  final Color pressColor;

  /// The color for the tile's [Material] when it has the input focus.
  final Color focusColor;

  /// The color for the tile's [Material] when a pointer is hovering over it.
  final Color hoverColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Add a one pixel border in between each tile. If color isn't specified the
  /// [ThemeData.dividerColor] of the context's [Theme] is used.
  ///
  /// See also:
  ///
  ///  * [Divider], which you can use to obtain this effect manually.
  static Iterable<Widget> divideTiles(
      {BuildContext context,
      @required Iterable<Widget> tiles,
      Color color}) sync* {
    assert(tiles != null);
    assert(color != null || context != null);

    final Iterator<Widget> iterator = tiles.iterator;
    final bool isNotEmpty = iterator.moveNext();

    final Decoration decoration = BoxDecoration(
      border: Border(
        bottom: BorderSide(color: color),
      ),
    );

    Widget tile = iterator.current;
    while (iterator.moveNext()) {
      yield DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: decoration,
        child: tile,
      );
      tile = iterator.current;
    }
    if (isNotEmpty) yield tile;
  }

  Color _iconColor(
      BuildContext context, CupertinoThemeData theme, ListTileTheme tileTheme) {
    if (!enabled)
      return CupertinoDynamicColor.resolve(
          CupertinoColors.placeholderText, context);

    if (selected && tileTheme?.selectedColor != null)
      return tileTheme.selectedColor;

    if (!selected && tileTheme?.iconColor != null) return tileTheme.iconColor;

    if (selected) return theme.primaryColor;

    return null;
  }

  Color _textColor(BuildContext context, CupertinoThemeData theme,
      ListTileTheme tileTheme, Color defaultColor) {
    if (!enabled)
      return CupertinoDynamicColor.resolve(
          CupertinoColors.placeholderText, context);

    if (selected && tileTheme?.selectedColor != null)
      return tileTheme.selectedColor;

    if (!selected && tileTheme?.textColor != null) return tileTheme.textColor;

    if (selected) return theme.primaryColor;

    return defaultColor;
  }

  bool _isDenseLayout(ListTileTheme tileTheme) {
    return dense ?? tileTheme?.dense ?? false;
  }

  TextStyle _titleTextStyle(
      BuildContext context, CupertinoThemeData theme, ListTileTheme tileTheme) {
    TextStyle style = theme.textTheme.textStyle;
    final Color color = _textColor(context, theme, tileTheme, style.color);
    return _isDenseLayout(tileTheme)
        ? style.copyWith(fontSize: 13.0, color: color)
        : style.copyWith(color: color);
  }

  TextStyle _subtitleTextStyle(
      BuildContext context, CupertinoThemeData theme, ListTileTheme tileTheme) {
    final TextStyle style = theme.textTheme.tabLabelTextStyle;
    final Color color =
        _textColor(context, theme, tileTheme, theme.textTheme.textStyle.color);
    return _isDenseLayout(tileTheme)
        ? style.copyWith(color: color, fontSize: 12.0)
        : style.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData theme = CupertinoTheme.of(context);
    final ListTileTheme tileTheme = ListTileTheme.of(context);

    IconThemeData iconThemeData;
    if (leading != null || trailing != null)
      iconThemeData =
          IconThemeData(color: _iconColor(context, theme, tileTheme));

    Widget leadingIcon;
    if (leading != null) {
      leadingIcon = IconTheme.merge(
        data: iconThemeData,
        child: leading,
      );
    }

    final TextStyle titleStyle = _titleTextStyle(context, theme, tileTheme);
    final Widget titleText = DefaultTextStyle(
      style: titleStyle,
      child: title ?? const SizedBox(),
    );

    Widget subtitleText;
    TextStyle subtitleStyle;
    if (subtitle != null) {
      subtitleStyle = _subtitleTextStyle(context, theme, tileTheme);
      subtitleText = DefaultTextStyle(
        style: subtitleStyle,
        child: subtitle,
      );
    }

    Widget trailingIcon;
    if (trailing != null) {
      trailingIcon = IconTheme.merge(
        data: iconThemeData,
        child: trailing,
      );
    } else {
      trailingIcon = Icon(CupertinoIcons.right_chevron,
          color: CupertinoDynamicColor.resolve(
              CupertinoColors.separator, context));
    }

    const EdgeInsets _defaultContentPadding =
        EdgeInsets.symmetric(horizontal: 16.0);
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding =
        contentPadding?.resolve(textDirection) ??
            tileTheme?.contentPadding?.resolve(textDirection) ??
            _defaultContentPadding;

    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!enabled) MaterialState.disabled,
        if (selected) MaterialState.selected,
      },
    );

    final ShapeBorder border = Border(
      bottom: BorderSide(
          color: CupertinoDynamicColor.resolve(
              CupertinoColors.separator, context)),
    );

    return ListTileBackground(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      mouseCursor: effectiveMouseCursor,
      canRequestFocus: enabled,
      focusNode: focusNode,
      pressColor: pressColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      autofocus: autofocus,
      customBorder: border,
      child: Semantics(
        selected: selected,
        enabled: enabled,
        child: SafeArea(
          top: false,
          bottom: false,
          minimum: resolvedContentPadding,
          child: _ListTile(
            leading: leadingIcon,
            title: titleText,
            subtitle: subtitleText,
            trailing: trailingIcon,
            isDense: _isDenseLayout(tileTheme),
            isThreeLine: isThreeLine,
            textDirection: textDirection,
            titleBaselineType:
                titleStyle.textBaseline ?? TextBaseline.alphabetic,
            subtitleBaselineType:
                subtitleStyle?.textBaseline ?? TextBaseline.alphabetic,
          ),
        ),
      ),
    );
  }
}

// Identifies the children of a _ListTileElement.
enum _ListTileSlot {
  leading,
  title,
  subtitle,
  trailing,
}

class _ListTile extends RenderObjectWidget {
  const _ListTile({
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    @required this.isThreeLine,
    @required this.isDense,
    @required this.textDirection,
    @required this.titleBaselineType,
    this.subtitleBaselineType,
  })  : assert(isThreeLine != null),
        assert(isDense != null),
        assert(textDirection != null),
        assert(titleBaselineType != null),
        super(key: key);

  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final bool isDense;
  final TextDirection textDirection;
  final TextBaseline titleBaselineType;
  final TextBaseline subtitleBaselineType;

  @override
  _ListTileElement createElement() => _ListTileElement(this);

  @override
  _RenderListTile createRenderObject(BuildContext context) {
    return _RenderListTile(
      isThreeLine: isThreeLine,
      isDense: isDense,
      textDirection: textDirection,
      titleBaselineType: titleBaselineType,
      subtitleBaselineType: subtitleBaselineType,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderListTile renderObject) {
    renderObject
      ..isThreeLine = isThreeLine
      ..isDense = isDense
      ..textDirection = textDirection
      ..titleBaselineType = titleBaselineType
      ..subtitleBaselineType = subtitleBaselineType;
  }
}

class _ListTileElement extends RenderObjectElement {
  _ListTileElement(_ListTile widget) : super(widget);

  final Map<_ListTileSlot, Element> slotToChild = <_ListTileSlot, Element>{};
  final Map<Element, _ListTileSlot> childToSlot = <Element, _ListTileSlot>{};

  @override
  _ListTile get widget => super.widget as _ListTile;

  @override
  _RenderListTile get renderObject => super.renderObject as _RenderListTile;

  @override
  void visitChildren(ElementVisitor visitor) {
    slotToChild.values.forEach(visitor);
  }

  @override
  void forgetChild(Element child) {
    assert(slotToChild.values.contains(child));
    assert(childToSlot.keys.contains(child));
    final _ListTileSlot slot = childToSlot[child];
    childToSlot.remove(child);
    slotToChild.remove(slot);
    super.forgetChild(child);
  }

  void _mountChild(Widget widget, _ListTileSlot slot) {
    final Element oldChild = slotToChild[slot];
    final Element newChild = updateChild(oldChild, widget, slot);
    if (oldChild != null) {
      slotToChild.remove(slot);
      childToSlot.remove(oldChild);
    }
    if (newChild != null) {
      slotToChild[slot] = newChild;
      childToSlot[newChild] = slot;
    }
  }

  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _mountChild(widget.leading, _ListTileSlot.leading);
    _mountChild(widget.title, _ListTileSlot.title);
    _mountChild(widget.subtitle, _ListTileSlot.subtitle);
    _mountChild(widget.trailing, _ListTileSlot.trailing);
  }

  void _updateChild(Widget widget, _ListTileSlot slot) {
    final Element oldChild = slotToChild[slot];
    final Element newChild = updateChild(oldChild, widget, slot);
    if (oldChild != null) {
      childToSlot.remove(oldChild);
      slotToChild.remove(slot);
    }
    if (newChild != null) {
      slotToChild[slot] = newChild;
      childToSlot[newChild] = slot;
    }
  }

  @override
  void update(_ListTile newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _updateChild(widget.leading, _ListTileSlot.leading);
    _updateChild(widget.title, _ListTileSlot.title);
    _updateChild(widget.subtitle, _ListTileSlot.subtitle);
    _updateChild(widget.trailing, _ListTileSlot.trailing);
  }

  void _updateRenderObject(RenderBox child, _ListTileSlot slot) {
    switch (slot) {
      case _ListTileSlot.leading:
        renderObject.leading = child;
        break;
      case _ListTileSlot.title:
        renderObject.title = child;
        break;
      case _ListTileSlot.subtitle:
        renderObject.subtitle = child;
        break;
      case _ListTileSlot.trailing:
        renderObject.trailing = child;
        break;
    }
  }

  @override
  void insertChildRenderObject(RenderObject child, dynamic slotValue) {
    assert(child is RenderBox);
    assert(slotValue is _ListTileSlot);
    final _ListTileSlot slot = slotValue as _ListTileSlot;
    _updateRenderObject(child as RenderBox, slot);
    assert(renderObject.childToSlot.keys.contains(child));
    assert(renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    assert(child is RenderBox);
    assert(renderObject.childToSlot.keys.contains(child));
    _updateRenderObject(null, renderObject.childToSlot[child]);
    assert(!renderObject.childToSlot.keys.contains(child));
    assert(!renderObject.slotToChild.keys.contains(slot));
  }

  @override
  void moveChildRenderObject(RenderObject child, dynamic slotValue) {
    assert(false, 'not reachable');
  }
}

class _RenderListTile extends RenderBox {
  _RenderListTile({
    @required bool isDense,
    @required bool isThreeLine,
    @required TextDirection textDirection,
    @required TextBaseline titleBaselineType,
    TextBaseline subtitleBaselineType,
  })  : assert(isDense != null),
        assert(isThreeLine != null),
        assert(textDirection != null),
        assert(titleBaselineType != null),
        _isDense = isDense,
        _isThreeLine = isThreeLine,
        _textDirection = textDirection,
        _titleBaselineType = titleBaselineType,
        _subtitleBaselineType = subtitleBaselineType;

  static const double _minLeadingWidth = 40.0;
  // The horizontal gap between the titles and the leading/trailing widgets
  double get _horizontalTitleGap => 16.0;
  // The minimum padding on the top and bottom of the title and subtitle widgets.
  static const double _minVerticalPadding = 4.0;

  final Map<_ListTileSlot, RenderBox> slotToChild =
      <_ListTileSlot, RenderBox>{};
  final Map<RenderBox, _ListTileSlot> childToSlot =
      <RenderBox, _ListTileSlot>{};

  RenderBox _updateChild(
      RenderBox oldChild, RenderBox newChild, _ListTileSlot slot) {
    if (oldChild != null) {
      dropChild(oldChild);
      childToSlot.remove(oldChild);
      slotToChild.remove(slot);
    }
    if (newChild != null) {
      childToSlot[newChild] = slot;
      slotToChild[slot] = newChild;
      adoptChild(newChild);
    }
    return newChild;
  }

  RenderBox _leading;
  RenderBox get leading => _leading;
  set leading(RenderBox value) {
    _leading = _updateChild(_leading, value, _ListTileSlot.leading);
  }

  RenderBox _title;
  RenderBox get title => _title;
  set title(RenderBox value) {
    _title = _updateChild(_title, value, _ListTileSlot.title);
  }

  RenderBox _subtitle;
  RenderBox get subtitle => _subtitle;
  set subtitle(RenderBox value) {
    _subtitle = _updateChild(_subtitle, value, _ListTileSlot.subtitle);
  }

  RenderBox _trailing;
  RenderBox get trailing => _trailing;
  set trailing(RenderBox value) {
    _trailing = _updateChild(_trailing, value, _ListTileSlot.trailing);
  }

  // The returned list is ordered for hit testing.
  Iterable<RenderBox> get _children sync* {
    if (leading != null) yield leading;
    if (title != null) yield title;
    if (subtitle != null) yield subtitle;
    if (trailing != null) yield trailing;
  }

  bool get isDense => _isDense;
  bool _isDense;
  set isDense(bool value) {
    assert(value != null);
    if (_isDense == value) return;
    _isDense = value;
    markNeedsLayout();
  }

  bool get isThreeLine => _isThreeLine;
  bool _isThreeLine;
  set isThreeLine(bool value) {
    assert(value != null);
    if (_isThreeLine == value) return;
    _isThreeLine = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  TextBaseline get titleBaselineType => _titleBaselineType;
  TextBaseline _titleBaselineType;
  set titleBaselineType(TextBaseline value) {
    assert(value != null);
    if (_titleBaselineType == value) return;
    _titleBaselineType = value;
    markNeedsLayout();
  }

  TextBaseline get subtitleBaselineType => _subtitleBaselineType;
  TextBaseline _subtitleBaselineType;
  set subtitleBaselineType(TextBaseline value) {
    if (_subtitleBaselineType == value) return;
    _subtitleBaselineType = value;
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    for (final RenderBox child in _children) child.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    for (final RenderBox child in _children) child.detach();
  }

  @override
  void redepthChildren() {
    _children.forEach(redepthChild);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    _children.forEach(visitor);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> value = <DiagnosticsNode>[];
    void add(RenderBox child, String name) {
      if (child != null) value.add(child.toDiagnosticsNode(name: name));
    }

    add(leading, 'leading');
    add(title, 'title');
    add(subtitle, 'subtitle');
    add(trailing, 'trailing');
    return value;
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading.getMinIntrinsicWidth(height), _minLeadingWidth) +
            _horizontalTitleGap
        : 0.0;
    return leadingWidth +
        math.max(_minWidth(title, height), _minWidth(subtitle, height)) +
        _maxWidth(trailing, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _horizontalTitleGap
        : 0.0;
    return leadingWidth +
        math.max(_maxWidth(title, height), _maxWidth(subtitle, height)) +
        _maxWidth(trailing, height);
  }

  double get _defaultTileHeight {
    final bool hasSubtitle = subtitle != null;
    final bool isTwoLine = !isThreeLine && hasSubtitle;
    final bool isOneLine = !isThreeLine && !hasSubtitle;

    if (isOneLine) return (isDense ? 48.0 : 56.0);
    if (isTwoLine) return (isDense ? 64.0 : 72.0);
    return (isDense ? 76.0 : 88.0);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return math.max(
      _defaultTileHeight,
      title.getMinIntrinsicHeight(width) +
          (subtitle?.getMinIntrinsicHeight(width) ?? 0.0),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(title != null);
    final BoxParentData parentData = title.parentData as BoxParentData;
    return parentData.offset.dy + title.getDistanceToActualBaseline(baseline);
  }

  static double _boxBaseline(RenderBox box, TextBaseline baseline) {
    return box.getDistanceToBaseline(baseline);
  }

  static Size _layoutBox(RenderBox box, BoxConstraints constraints) {
    if (box == null) return Size.zero;
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData as BoxParentData;
    parentData.offset = offset;
  }

  // All of the dimensions below were taken from the Material Design spec:
  // https://material.io/design/components/lists.html#specs
  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasSubtitle = subtitle != null;
    final bool hasTrailing = trailing != null;
    final bool isTwoLine = !isThreeLine && hasSubtitle;
    final bool isOneLine = !isThreeLine && !hasSubtitle;

    final BoxConstraints maxIconHeightConstraint = BoxConstraints(
      // One-line trailing and leading widget heights do not follow
      // Material specifications, but this sizing is required to adhere
      // to accessibility requirements for smallest tappable widget.
      // Two- and three-line trailing widget heights are constrained
      // properly according to the Material spec.
      maxHeight: (isDense ? 48.0 : 56.0),
    );
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints =
        looseConstraints.enforce(maxIconHeightConstraint);

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    final Size trailingSize = _layoutBox(trailing, iconConstraints);
    assert(tileWidth != leadingSize.width,
        'Leading widget consumes entire tile width. Please use a sized widget.');
    assert(tileWidth != trailingSize.width,
        'Trailing widget consumes entire tile width. Please use a sized widget.');

    final double titleStart = hasLeading
        ? math.max(_minLeadingWidth, leadingSize.width) + _horizontalTitleGap
        : 0.0;
    final double adjustedTrailingWidth = hasTrailing
        ? math.max(trailingSize.width + _horizontalTitleGap, 32.0)
        : 0.0;
    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - adjustedTrailingWidth,
    );
    final Size titleSize = _layoutBox(title, textConstraints);
    final Size subtitleSize = _layoutBox(subtitle, textConstraints);

    double titleBaseline;
    double subtitleBaseline;
    if (isTwoLine) {
      titleBaseline = isDense ? 28.0 : 32.0;
      subtitleBaseline = isDense ? 48.0 : 52.0;
    } else if (isThreeLine) {
      titleBaseline = isDense ? 22.0 : 28.0;
      subtitleBaseline = isDense ? 42.0 : 48.0;
    } else {
      assert(isOneLine);
    }

    final double defaultTileHeight = _defaultTileHeight;

    double tileHeight;
    double titleY;
    double subtitleY;
    if (!hasSubtitle) {
      tileHeight = math.max(
          defaultTileHeight, titleSize.height + 2.0 * _minVerticalPadding);
      titleY = (tileHeight - titleSize.height) / 2.0;
    } else {
      assert(subtitleBaselineType != null);
      titleY = titleBaseline - _boxBaseline(title, titleBaselineType);
      subtitleY =
          subtitleBaseline - _boxBaseline(subtitle, subtitleBaselineType);
      tileHeight = defaultTileHeight;

      // If the title and subtitle overlap, move the title upwards by half
      // the overlap and the subtitle down by the same amount, and adjust
      // tileHeight so that both titles fit.
      final double titleOverlap = titleY + titleSize.height - subtitleY;
      if (titleOverlap > 0.0) {
        titleY -= titleOverlap / 2.0;
        subtitleY += titleOverlap / 2.0;
      }

      // If the title or subtitle overflow tileHeight then punt: title
      // and subtitle are arranged in a column, tileHeight = column height plus
      // _minVerticalPadding on top and bottom.
      if (titleY < _minVerticalPadding ||
          (subtitleY + subtitleSize.height + _minVerticalPadding) >
              tileHeight) {
        tileHeight =
            titleSize.height + subtitleSize.height + 2.0 * _minVerticalPadding;
        titleY = _minVerticalPadding;
        subtitleY = titleSize.height + _minVerticalPadding;
      }
    }

    // This attempts to implement the redlines for the vertical position of the
    // leading and trailing icons on the spec page:
    //   https://material.io/design/components/lists.html#specs
    // The interpretation for these redlines is as follows:
    //  - For large tiles (> 72dp), both leading and trailing controls should be
    //    a fixed distance from top. As per guidelines this is set to 16dp.
    //  - For smaller tiles, trailing should always be centered. Leading can be
    //    centered or closer to the top. It should never be further than 16dp
    //    to the top.
    double leadingY;
    double trailingY;
    if (tileHeight > 72.0) {
      leadingY = 16.0;
      trailingY = 16.0;
    } else {
      leadingY = math.min((tileHeight - leadingSize.height) / 2.0, 16.0);
      trailingY = (tileHeight - trailingSize.height) / 2.0;
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          if (hasLeading)
            _positionBox(
                leading, Offset(tileWidth - leadingSize.width, leadingY));
          _positionBox(title, Offset(adjustedTrailingWidth, titleY));
          if (hasSubtitle)
            _positionBox(subtitle, Offset(adjustedTrailingWidth, subtitleY));
          if (hasTrailing) _positionBox(trailing, Offset(0.0, trailingY));
          break;
        }
      case TextDirection.ltr:
        {
          if (hasLeading) _positionBox(leading, Offset(0.0, leadingY));
          _positionBox(title, Offset(titleStart, titleY));
          if (hasSubtitle)
            _positionBox(subtitle, Offset(titleStart, subtitleY));
          if (hasTrailing)
            _positionBox(
                trailing, Offset(tileWidth - trailingSize.width, trailingY));
          break;
        }
    }

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(title);
    doPaint(subtitle);
    doPaint(trailing);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {@required Offset position}) {
    assert(position != null);
    for (final RenderBox child in _children) {
      final BoxParentData parentData = child.parentData as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
    }
    return false;
  }
}
