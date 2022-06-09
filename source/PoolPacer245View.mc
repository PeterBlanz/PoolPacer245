import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Attention;

class PoolPacer245View extends WatchUi.DataField
{
    hidden var _nextAlert as Float;
    hidden var _nAlerts as Number;
    hidden var _interval as Float;
    hidden var _vibeData as Array;

    function initialize()
    {
    	// basic initialization
        DataField.initialize();
        _nAlerts = 1;
        
        // create vibration sequence
        _vibeData = new[Application.getApp().getProperty("vibrationCount") * 2 - 1];
        var period = Application.getApp().getProperty("vibrationPeriod");
        for(var i = 0; i < _vibeData.size(); i++)
        {
        	_vibeData[i] = new Attention.VibeProfile(i % 2 == 0 ? 100 : 0, period);
        }
        
        // initialize alarm interval
        var pace = Application.getApp().getProperty("targetPace");        
        _interval = 0.25f * (pace == null ? 120 : pace);
	    _nextAlert = _interval;
    }

    // Set your layout here. Anytime the size of obscurity of the draw context is changed this will be called.
    function onLayout(dc as Dc) as Void
    {
        var obscurityFlags = DataField.getObscurityFlags();

        // quadrant layouts
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT))
        {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));
        }
        else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT))
        {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));
        }
        else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT))
        {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));
        }
        else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT))
        {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));
        }

        // generic, centered layout
        else
        {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 16;
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
        }

        (View.findDrawableById("label") as Text).setText("Next alert (s)");
    }

    // The given info object contains all the current workout information. Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void
    {
	    if((info.timerTime as Number) * 0.001f >= _nextAlert)
	    {
	    	_nAlerts += 1;
	    	_nextAlert = _nAlerts * _interval;
	    	Attention.vibrate(_vibeData);
	    }
    }

    // Display the value you computed here. This will be called once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void
    {
        // set the background color
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // set the foreground color and value
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK)
        {
            value.setColor(Graphics.COLOR_WHITE);
        }
        else
        {
            value.setColor(Graphics.COLOR_BLACK);
        }
        value.setText(_nextAlert.format("%.2f"));

        // call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }
}
