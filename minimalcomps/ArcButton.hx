package minimalcomps;

/**
 * ArcButton class. Internal class only used by WheelMenu.
 */
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.Shape;

class ArcButton extends Sprite {
	public var id : Int;
	
	public var color(get, set) : UInt;
	public var arcRotation(get, set) : Float;
	public var borderColor(get, set) : UInt;

	var _arc:Float;
	var _bg:Shape;
	var _borderColor:UInt;
	var _color:UInt;
	var _highlightColor:UInt;
	var _icon:Dynamic;
	var _iconHolder:Sprite;
	var _iconRadius:Float;
	var _innerRadius:Float;
	var _outerRadius:Float;

	/**
	 * Constructor.
	 * @param arc The radians of the arc to draw.
	 * @param outerRadius The outer radius of the arc. 
	 * @param innerRadius The inner radius of the arc.
	 */
	public function new(arc:Float, outerRadius:Float, iconRadius:Float, innerRadius:Float) {
		super();
		_arc = arc;
		_outerRadius = outerRadius;
		_iconRadius = iconRadius;
		_innerRadius = innerRadius;
		_borderColor = 0xCCCCCC;
		_color = 0xFFFFFF;
		_highlightColor = 0xEEEEEE;

		_bg = new Shape();
		addChild(_bg);

		_iconHolder = new Sprite();
		addChild(_iconHolder);

		drawArc(0xffffff);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	///////////////////////////////////
	// private methods
	///////////////////////////////////

	/**
	 * Draws an arc of the specified color.
	 * @param color The color to draw the arc.
	 */
	function drawArc(color:UInt) {
		_bg.graphics.clear();
		_bg.graphics.lineStyle(2, _borderColor);
		_bg.graphics.beginFill(color);
		_bg.graphics.moveTo(_innerRadius, 0);
		_bg.graphics.lineTo(_outerRadius, 0);
		var i = 0.;
		while( i < _arc ) {
			_bg.graphics.lineTo(Math.cos(i) * _outerRadius, Math.sin(i) * _outerRadius);
			i += .05;
		}
		_bg.graphics.lineTo(Math.cos(_arc) * _outerRadius, Math.sin(_arc) * _outerRadius);
		_bg.graphics.lineTo(Math.cos(_arc) * _innerRadius, Math.sin(_arc) * _innerRadius);
		var i = 0.;
		while( i < _arc ) {
			_bg.graphics.lineTo(Math.cos(i) * _innerRadius, Math.sin(i) * _innerRadius);
			i += .05;
		}
		_bg.graphics.lineTo(_innerRadius, 0);
		_bg.graphics.endFill();
	}

	///////////////////////////////////
	// public methods
	///////////////////////////////////

	/**
	 * Sets the icon or label of this button.
	 * @param iconOrLabel Either a display object instance, a class that extends DisplayObject, or text to show in a label.
	 */
	public function setIcon( iconOrLabel : Dynamic ) {
        if(iconOrLabel == null) return;
        while(_iconHolder.numChildren > 0) _iconHolder.removeChildAt(0);
		if( Std.is( iconOrLabel , Class ) )
			_icon = cast( Type.createInstance( cast iconOrLabel , [] ) , DisplayObject );
		else if( Std.is( iconOrLabel , DisplayObject ) )
			_icon = cast( iconOrLabel , DisplayObject );
		else if( Std.is( iconOrLabel , String ) ) {
			_icon = new Label(null, 0, 0, cast( iconOrLabel , String ) );
			cast( _icon , Label ).draw();
		}
		if(_icon != null) {
			var angle = _bg.rotation * Math.PI / 180;
			_icon.x = Math.round(-_icon.width / 2);
			_icon.y = Math.round(-_icon.height / 2);
			_iconHolder.addChild(_icon);
			_iconHolder.x = Math.round(Math.cos(angle + _arc / 2) * _iconRadius);
			_iconHolder.y = Math.round(Math.sin(angle + _arc / 2) * _iconRadius);
		}
	}

	///////////////////////////////////
	// event handlers
	///////////////////////////////////

	/**
	 * Called when mouse moves over this button. Draws highlight.
	 */
	function onMouseOver(event:MouseEvent) drawArc(_highlightColor);

	/**
	 * Called when mouse moves out of this button. Draw base color.
	 */
	function onMouseOut(event:MouseEvent) drawArc(_color);

	/**
	 * Called when mouse is released over this button. Dispatches select event.
	 */
	function onMouseUp(event:MouseEvent) dispatchEvent(new Event(Event.SELECT));


	///////////////////////////////////
	// getter / setters
	///////////////////////////////////

	/**
	 * Sets / gets border color.
	 */
	function set_borderColor( value : UInt ) {
		_borderColor = value;
		drawArc(_color);
		return _borderColor;
	}
	function get_borderColor() {
        return _borderColor;
	}

	/**
	 * Sets / gets base color.
	 */
	function set_color(value:UInt) {
		_color = value;
		drawArc(_color);
		return _color;
	}
	function get_color() {
		return _color;
	}

	function set_arcRotation(value : Float) {
		_arc = value;
		return _arc;
	}
	function get_arcRotation() {
		return _arc;
	}
	
	/**
	 * Overrides rotation by rotating arc only, allowing label / icon to be unrotated.
	 */
	function set_rotation(value:Float) {
		return _bg.rotation = value;
	}
	function get_rotation():Float {
		return _bg.rotation;
	}    
}
