import 'package:app_invernadero/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  final Widget leading;
  final List<Widget> actions;
  final Function onChanged;


  const SearchAppBar({
    Key key, 
    @required this.title, 
    this.leading,
     this.actions,
    @required this.onChanged,}) : super(key: key);

  

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size(double.infinity, kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(LineIcons.search,color: Colors.grey,);
  Widget _appBarTitle;
  List<Widget> _actions;
  Responsive responsive;
  
  @override
  void didChangeDependencies() {
    responsive = Responsive.of(context);
    _actions = [];
    _appBarTitle =  Text(
        this.widget.title,
        style:TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w900,
          fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
        ) ,
      );
    _searchIcon = new Icon(LineIcons.search,color: Colors.grey,);

    _actions.add( IconButton(icon: _searchIcon , onPressed: _searchPressed),);

    if(this.widget.actions!=null){
   this.widget.actions.forEach((f){
      Widget itemAction = f;
      _actions.add(itemAction);
    });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
     brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      centerTitle: true,
      title: _appBarTitle,
      leading:this.widget.leading,
      actions: _actions,
    );
  }
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == LineIcons.search) {
        this._searchIcon = new Icon(LineIcons.times_circle,color: Colors.grey,);
        this._appBarTitle = new TextField(
          controller: _filter,
          onChanged: (f)=>this.widget.onChanged(f),
          decoration: new InputDecoration(
            hintText: 'Buscar...',
            focusedBorder:  UnderlineInputBorder(      
              borderSide: BorderSide(color:Color(0xffdddddd))),
            enabledBorder: UnderlineInputBorder(      
                          borderSide: BorderSide(color:Color(0xffdddddd)),),
          ),
        );
      } else {
        this._searchIcon = new Icon(LineIcons.search,color: Colors.grey,);
        this._appBarTitle =Text(
          this.widget.title,
          style:TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.w900,
            fontSize:responsive.ip(2.5),color:Color(0xFF545D68)
          ) ,
        );
        _filter.clear();
      }
    });
  }
  

}