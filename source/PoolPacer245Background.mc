import Toybox.Application;
import Toybox.Graphics;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable
{

    hidden var _color as ColorValue;

    function initialize()
    {
        var dictionary =
        {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);

        _color = Graphics.COLOR_WHITE;
    }

    function setColor(color as ColorValue) as Void
    {
        _color = color;
    }

    function draw(dc as Dc) as Void
    {
        dc.setColor(Graphics.COLOR_TRANSPARENT, _color);
        dc.clear();
    }

}
