#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-
###############################################################################
#
# Copyright 2006 - 2018, Paul Beckingham, Federico Hernandez.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# https://www.opensource.org/licenses/mit-license.php
#
###############################################################################

import sys
import os
import unittest
from datetime import datetime
# Ensure python finds the local simpletap module
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from basetest import Task, TestCase
from basetest import Taskd, ServerTestCase


class TestBug1904(TestCase):
    """Testing for correct order of sub/projects with different characters.

    The bug arises when we have a project like 'a-b', and a project with
    subproject 'a.b'.
    Due to the internal ordering of projects, the 'a-b' project appears
    between the parent project 'a' and the sub-project 'b'.

    """

    def setUp(self):
        self.t = Task()

    def test_project_ordering(self):
        self.t('add pro:a-b test1')
        self.t('add pro:a.b test2')
        _code, out, _err = self.t('projects')
        lines = out.split('\n')
        first_project_line = next(i for i, line in enumerate(lines)
                                  if line.startswith('a'))

        # It doesn't matter if 'a+b' is first or last, but not in the middle
        self.assertRegexpMatches(lines[first_project_line], r'a\s')
        self.assertRegexpMatches(lines[first_project_line+1], r'\s+b\s')
        self.assertRegexpMatches(lines[first_project_line+2], r'a-b\s')


if __name__ == "__main__":
    from simpletap import TAPTestRunner
    unittest.main(testRunner=TAPTestRunner())

# vim: ai sts=4 et sw=4 ft=python
