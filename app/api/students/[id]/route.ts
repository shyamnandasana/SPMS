import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { hashPassword } from "@/lib/auth";

export const dynamic = 'force-dynamic';

// GET: Fetch Single Student
export async function GET(request: Request, { params }: { params: Promise<{ id: string }> }) {
    try {
        const { id } = await params;

        const student = await prisma.user.findUnique({
            where: { id },
            include: {
                StudentProfile: {
                    include: {
                        ProjectGroup: {
                            include: {
                                Project: true
                            }
                        }
                    }
                }
            }
        });

        if (!student || student.role !== 'STUDENT') {
            return NextResponse.json({ error: "Student not found" }, { status: 404 });
        }

        return NextResponse.json(student);
    } catch (error) {
        console.error("Error fetching student:", error);
        return NextResponse.json({ error: "Failed to fetch student" }, { status: 500 });
    }
}

// PUT: Update Student
export async function PUT(request: Request, { params }: { params: Promise<{ id: string }> }) {
    try {
        const { id } = await params;

        const body = await request.json();
        const { name, email, idNumber, department, batch, isActive, isLeader, password } = body;

        // Prepare update data
        const updateData: any = {
            fullName: name,
            email,
            isActive: isActive !== undefined ? isActive : undefined,
            StudentProfile: {
                update: {
                    idNumber,
                    department,
                    batch,
                    isLeader: isLeader !== undefined ? isLeader : undefined
                }
            }
        };

        // If password is provided (limit to non-empty strings), hash and update it
        if (password && password.trim() !== "") {
            updateData.password = await hashPassword(password);
        }

        const updatedUser = await prisma.user.update({
            where: { id },
            data: updateData,
            include: { StudentProfile: true }
        });

        return NextResponse.json(updatedUser);
    } catch (error) {
        console.error("Error updating student:", error);
        return NextResponse.json({ error: "Failed to update student" }, { status: 500 });
    }
}

// DELETE: Remove Student
export async function DELETE(request: Request, { params }: { params: Promise<{ id: string }> }) {
    try {
        const { id } = await params;
        await prisma.user.delete({
            where: { id }
        });
        return NextResponse.json({ message: "Student deleted" });
    } catch (error) {
        return NextResponse.json({ error: "Failed to delete student" }, { status: 500 });
    }
}
