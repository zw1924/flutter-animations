import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Sandbox extends StatefulWidget {
  @override
  _SandboxState createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  double _opacity = 1.0;
  double _margin = 0.0;
  double _width = 200.0;
  Color _color = Colors.blue;

  bool appear = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
          duration: Duration(seconds: 1),
          margin: EdgeInsets.all(_margin),
          width: _width,
          color: _color,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              RaisedButton(
                child: Text('animate margin'),
                onPressed: () =>
                    setState(() => _margin = (_margin == 50.0) ? 0 : 50.0),
              ),
              RaisedButton(
                child: Text('animate color'),
                onPressed: () => setState(() => _color =
                    (_color == Colors.blue) ? Colors.purple : Colors.blue),
              ),
              RaisedButton(
                child: Text('animate width'),
                onPressed: () =>
                    setState(() => _width = ((_width == 400 ? 200 : 400))),
              ),
              RaisedButton(
                child: Text('animate opacity'),
                onPressed: () =>
                    setState(() => _opacity = (_opacity == 0 ? 1.0 : 0.0)),
              ),
              SizedBox(height: 100),
              AnimatedOpacity(
                duration: Duration(seconds: 2),
                opacity: _opacity,
                child: Text('hide me', style: TextStyle(color: Colors.white)),
              ),
              RaisedButton(
                child: Text(appear ? '小球升起来' : '小球降下去'),
                onPressed: () => setState(() => appear = !appear),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedPositioned(
                      left: 50,
                      top: appear ? 10 : 600,
                      duration: Duration(seconds: 2),
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(appear?20:0)
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
