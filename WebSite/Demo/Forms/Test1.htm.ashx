﻿<%@ WebHandler Language="C#" Class="Test1" %>

using System;
using System.Web;
using System.Linq;
using Ivony.Fluent;
using Ivony.Html;
using Ivony.Html.Styles;
using Ivony.Html.Forms;
using Ivony.Html.Forms.Validation;
using Ivony.Html.HtmlAgilityPackAdaptor;
using Ivony.Html.Parser;

public class Test1 : JumonyHandler
{
  protected override void Process()
  {

    Find( "table tr td:nth-child(1)" ).Where( e => e.Attribute( "style" ) == null ).Style().Set( "text-align", "right" );


    var form = new HtmlForm( Document.FindSingle( "form" ) );

    if ( Request.Form.Count > 0 )
    {
      form.Submit( Request.Form );

      new MyValidator( form ).Validate();

      form.ApplySubmittedValue();
    }

  }

  private class MyValidator : HtmlFormValidator
  {
    public MyValidator( HtmlForm form )
      : base( form )
    {
      AddFieldValidation( "userID", "用户ID", new RequiredValidator(), new IntegerValidator() );
      AddFieldValidation( "username", "用户名", new RequiredValidator() );
      AddFieldValidation( "password", "密码", new RequiredValidator() );
    }

    protected override IHtmlElement GetMessageContainer( IHtmlInputControl input )
    {

      IHtmlElement inputElement = null;

      var inputText = input as HtmlInputText;
      if ( inputText != null )
        inputElement = inputText.Element;


      if ( inputElement != null )
        return inputElement.Ancestors( "tr" ).First().Elements( "td" ).Last();

      else
        return null;
    }
  }

}