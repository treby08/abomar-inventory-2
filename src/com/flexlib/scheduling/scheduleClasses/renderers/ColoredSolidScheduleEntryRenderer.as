/*
   Copyright (c) 2006. Adobe Systems Incorporated.
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 * Neither the name of Adobe Systems Incorporated nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE.

 */
package com.flexlib.scheduling.scheduleClasses.renderers
{
  import com.flexlib.scheduling.scheduleClasses.ColoredScheduleEntry;
  import com.flexlib.scheduling.scheduleClasses.IScheduleEntry;
  import com.flexlib.scheduling.scheduleClasses.SimpleScheduleEntry;
  import flexlib.scheduling.scheduleClasses.renderers.AbstractSolidScheduleEntryRenderer;


  public class ColoredSolidScheduleEntryRenderer extends AbstractSolidScheduleEntryRenderer
  {
    public function ColoredSolidScheduleEntryRenderer()
    {
      super();
    }

    override public function set data(value:Object):void
    {
      super.data = value;

      entry = value as IScheduleEntry;
      var content:ColoredScheduleEntry = ColoredScheduleEntry(entry);

      setStyle("backgroundColor", content.backgroundColor);

      setTextContent(SimpleScheduleEntry(content));
    }
  }
}